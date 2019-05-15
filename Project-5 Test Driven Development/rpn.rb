# Class to evaluate RPN expressions
class RPN
  def initialize(length)
    @args_length = length
    @master_file = File.open('mufaro_sam_d6.rpn', 'a+', File::CREAT)
    @keywords = %w[print let quit]
    @operators = %w[+ - * /]
    @alphabet = [*('a'..'z')]
    @variables_dict = Hash[@alphabet.map { |x| [x, nil] }]
    @file_use = false
    @line_counter = 1
  end

  def read_hash_value(letter)
    @variables_dict[letter]
  end

  def check_args_length
    @args_length.zero? # takes ARGV.length as an argument
  end

  def read_file(file)
    puts 'FILE IS NIL' && 'SYSTEM EXIT' if file.nil?
  end

  def concatenate(file_line)
    @master_file << file_line
  end

  def new_line
    @master_file << "\n"
  end

  attr_reader :master_file
  attr_accessor :file_use
  attr_accessor :line_counter

  # utility classes that check if the argument is of a numeric, letter, or operator symbol type
  # return nil if its not the respective type
  # return 0 if its a single character of that respective type

  def self.numeric?(look_ahead)
    look_ahead =~ /[[:digit:]]/
  end

  def self.letter?(look_ahead)
    look_ahead =~ /[[:alpha:]]/
  end

  def self.symbol?(look_ahead)
    look_ahead =~ /[[:[*+\/-]:]]/
  end

  # Quits program when user types quit.
  def quit(quit_keyword)
    quit_keyword = quit_keyword.downcase
    exit if quit_keyword.eql? @keywords[2]
  end

  # Checks if the let keyword is input
  def check_let(let_keyword)
    let_keyword = let_keyword.downcase
    return false unless let_keyword.eql? @keywords[1]
    true
  end

  # Stores a letter with an associated number.
  def write_let(letter, number)
    letter = letter.downcase
    # Checks that valid letter used
    return false unless RPN.letter?(letter).zero?
    # If correct letter is used write the wanted value
    # Then store it as a variable in the variable array
    @variables_dict[letter] = number
    puts @variables_dict[letter] unless @file_use
  end

  # Checks if print keyword is inputed
  def check_print(print_keyword)
    print_keyword = print_keyword.downcase
    return false unless print_keyword.eql? @keywords[0]
    true
  end

  # Prints the result of the postfix calculation
  def print_result(result)
    puts result
  end

  # Calculated postfix notation given a space delimited expression
  def calculate_postfix_expression(expression)
    counter = 0
    stack = []
    expression_array = expression.split(' ')
    while counter != expression_array.length
      input = expression_array[counter]
      flag = false
      @variables_dict.keys.each do |key|
        if input.downcase == key && !@variables_dict[key].nil?
          variable_value = @variables_dict[key]
          stack.push(variable_value)
          flag = true
        elsif input.downcase == key && @variables_dict[key].nil? && !counter.zero?
          puts 'Line ' + @line_counter.to_s + ': Variable ' + key + ' is not initialized.'
          exit(1) if file_use
          break unless file_use
        end
      end
      if RPN.numeric?(input) == 0 || (RPN.numeric?(input) == 1 && input[0] == '-')
        input = input.to_i
        stack.push(input)
      elsif RPN.symbol?(input) == 0 && flag == false
        operand1 = stack.pop.to_i
        operand2 = stack.pop.to_i
        result = RPN.symbol_calculate(input, operand1, operand2)
        stack.push(result)
      end
      counter += 1
    end
    result
  end

  # Utility class
  def self.symbol_calculate(symbol, operand1, operand2)
    case symbol
    when '+'
      operand1 + operand2
    when '-'
      operand2 - operand1
    when '*'
      operand1 * operand2
    when '/'
      operand2 / operand1
    end
  end

  def self.var_initialized(var)
    var = var.downcase
    @variables_dict.keys.include?(var)
  end

  def rpn_driver(user_input, keyword, rpn)
    rpn.quit(keyword)
    if user_input.split(' ').length == 1
      puts keyword if RPN.numeric?(keyword) == 0 || (RPN.numeric?(user_input) == 1 && user_input[0] == '-')
      if RPN.letter?(keyword) == 0
        to_print = keyword.downcase
        value_print = @variables_dict[to_print]
        puts value_print
      end
    elsif rpn.check_let(keyword)
      letter = user_input.split(' ')[1]
      if user_input.split(' ').length <= 3
        letter = user_input.split(' ')[1]
        number = user_input.split(' ')[2]
        number.to_i
        rpn.write_let(letter, number)
      else
        start = keyword.length + letter.length
        ending = user_input.length - 2
        expression = user_input[start..ending]
        result = rpn.calculate_postfix_expression(expression)
        rpn.write_let(letter, result)
      end
    elsif rpn.check_print(keyword)
      if user_input.split(' ').length == 2
        to_print = user_input.split(' ')[1]
        if RPN.numeric?(to_print) == 0 || (RPN.numeric?(to_print) == 1 && to_print[0] == '-')
          puts to_print
        elsif RPN.letter?(to_print) == 0
          to_print = to_print.downcase
          value_print = @variables_dict[to_print]
          puts value_print
        end
      else
        start = keyword.length + 1
        ending = user_input.length - 2
        expression = user_input[start..ending]
        result = rpn.calculate_postfix_expression(expression)
        rpn.print_result(result)
      end
    else
      ending = user_input.length - 2
      expression = user_input[0..ending]
      result = rpn.calculate_postfix_expression(expression)
      rpn.print_result(result)
    end
    @line_counter += 1
  end
end

# Execution starts here
rpn_eval = RPN.new(ARGV.length)
args_zero = rpn_eval.check_args_length
the_true_true = true

begin
  if args_zero
    while the_true_true
      print '> '
      user_input = gets
      split_array = user_input.split(' ')
      if split_array.length.zero?
        rpn_eval.line_counter += 1
        next
      end
      keyword = split_array[0]
      rpn_eval.rpn_driver(user_input, keyword, rpn_eval)
    end
  else
    # read in the files and evaluate
    rpn_eval.file_use = true
    ARGV.each do |file|
      rpn_eval.read_file file

      text = File.read(file)
      text.each_line do |line|
        rpn_eval.concatenate(line)
      end

      rpn_eval.new_line unless file.eql?(ARGV[ARGV.length - 1])
    end

    rpn_eval.master_file.close
    concat_file = File.read('mufaro_sam_d6.rpn')

    concat_file.each_line do |line|
      split_array = line.split(' ')
      if split_array.length.zero?
        rpn_eval.line_counter += 1
        next
      end
      keyword = split_array[0]
      rpn_eval.rpn_driver(line, keyword, rpn_eval)
    end
  end

ensure
  rpn_eval.master_file.close
  File.delete('mufaro_sam_d6.rpn')
end
