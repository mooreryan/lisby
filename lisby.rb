# An environment: a hash of {'var'=>val} pairs, with an outer Env
class Env < Hash
  attr_accessor :outer
  
  def initialize parms=[], args=[], outer=nil
    parms_array = parms.zip args
    # update with the passed parms & args
    self.update Hash[*parms_array.flatten( 1 )]
    @outer = outer
  end
  
  # Find the innermost Env where var appears.
  def find var
    if self.has_key? var
      self
    else
      self.outer.find var unless self.outer.nil?
    end
  end
end

# Add some Scheme standard procedures to an environment.
def add_globals env
  operators = [:+, :-, :*, :/, :>, :<, :>=, :<=]
  operators.each { |op| env[op.to_s] = lambda { |x,y| x.send op, y } }
  env.update( { 'equal?' => lambda { |x,y| x.equal? y},
                '=' => lambda { |x,y| x.equal? y },
                'length' => lambda { |x| x.length },
                'cons' => lambda { |elem, arr| arr.unshift elem },
                'car' => lambda { |arr| arr.first },
                'cdr' => lambda { |arr| arr.drop 1 },
                'append' => lambda { |x, y| x + y },
                'list' => lambda { |*x| Array.new x },
                'list?' => lambda { |x| x.instance_of? Array },
                'null?' => lambda { |x| x == [] },
                'symbol?' => lambda { |x| x.instance_of? String } } )
  env
end

# Evaluate an expression in an environment.
def evaluate x, env
  if x.instance_of? String
    begin 
      env.find( x )[x]
    rescue
      puts "\nvar ref rescue!"
      puts "thing evaluated: #{x}"
    end
  elsif !x.instance_of? Array
    x
  elsif x[0] == 'quote'
    _, expr = x
    expr
  elsif x[0] == 'if'
    _, test, conseq, alt = x
    evaluate((if evaluate test, env; conseq; else; alt; end), env)
  elsif x[0] == 'set!'
    _, var, expr = x
    env[var] = evaluate expr, env
  elsif x[0] == 'define'
    _, var, expr = x
    env[var] = evaluate expr, env
  elsif x[0] == 'lambda' # need to throw error if x isnt len=3?
    _, vars, expr = x
    lambda { |*args| evaluate( expr, Env.new( vars, args, env )) }
  elsif x[0] == 'begin'
    val = nil
    x.drop( 1 ).each do |expr|
      val = evaluate( expr, env )
    end
    val
  else
    begin
      exprs = x.map { |expr| evaluate expr, env }
      procedure = exprs.shift
      procedure.call *exprs
    rescue
      puts "\nproc call rescue!"
      puts "exprs: #{exprs}"
      puts "proc: #{x.first} -- #{procedure}"
    end
  end
end


# Read a Scheme expr from a string.
def read s
  read_from tokenize s
end

# Convert a string into a list of tokens.
def tokenize s
  s.gsub( /\(/, ' ( ' ).gsub( /\)/, ' ) ' ).split
end

# Read an expression from a sequence of tokens.
def read_from tokens
  raise SytaxError, 'unexpected EOF while reading' if tokens.length.zero?
  
  token = tokens.shift
  if '(' == token
    arr = []
    until tokens.first == ')'
      arr << read_from( tokens )
    end
    tokens.shift # pop off ')'
    return arr
  elsif ')' == token
    raise SyntaxError, 'unexpected )'
  else
    return atom token
  end
end

# Try integer, then float then everything else is a string
def atom token
  begin
    Integer token
  rescue ArgumentError
    begin 
      Float token
    rescue ArgumentError
      String token
    end
  end
end
  
# Convert a Python object back into a Lisp-readable string.    
def to_string expr
  if expr.instance_of? Array
    "(#{expr.map { |exp| to_string exp }.join ' ' })"
  else
    String expr
  end
end

# A prompt read-eval-print loop
def repl prompt='lisby> '
  global_env = add_globals Env.new
  while true
    print prompt
    val = evaluate read( gets.chomp ), global_env
    unless val.nil?
      puts to_string val
    end
  end
end

repl
