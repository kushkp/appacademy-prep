class RPNCalculator

  OPERATIONS = {:+ => "plus", :- => "minus", :* => "times", :/ => "divide"}

  def initialize
    @stack = []
    @token_list = []
  end

  def push(num)
    @stack << num
  end

  def value
    @stack.last
  end

  def check_num_elements
    raise("calculator is empty") if @stack.length < 2
  end

  def plus
    check_num_elements
    @stack << @stack.pop + @stack.pop
  end

  def minus
    check_num_elements
    last = @stack.pop
    @stack << @stack.pop - last
  end

  def times
    check_num_elements
    @stack << @stack.pop * @stack.pop
  end

  def divide
    check_num_elements
    last = @stack.pop
    @stack << @stack.pop / last.to_f
  end

  def tokens(string)
    operators = %w[+ - * /]
    @token_list = string.split.map do |token|
      operators.include?(token) ? token.to_sym : token.to_i
    end
  end

  def prompt_user
    puts "Enter numbers or operators to calculate. Press Enter when done."
    users_string = ""
    input = gets.chomp
    while input != "" #Why does this not work with "unless input == "" "
      users_string << input
      users_string << " "
      input = gets.chomp
    end
    users_string
  end

  def evaluate(string)
    p tokens(string)
    until @token_list.empty?
      if @token_list.first.class == Fixnum
        @stack << @token_list.shift
      else
        check_num_elements
        send(OPERATIONS[@token_list.shift])
      end
    end
    value
  end

  def run
    user_input = (ARGV.empty? ? prompt_user : File.read("#{ARGV[0]}"))
    p evaluate(user_input)
  end
end

# test
calc = RPNCalculator.new
calc.run

# send(operator, 2nd num)
