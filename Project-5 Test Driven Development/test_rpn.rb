require 'minitest/autorun'
require_relative 'RPN'

class TestRPN < Minitest::Test
  # UNIT TESTS FOR RPN DECLARATION
  # Equivalence classes: n/a

  # Creates an RPN, refutes that it's nil, and asserts that it is a kind of RPN object.
  def test_new_RPN_not_nil
    rpn = RPN.new(2)
    refute_nil rpn
    assert_kind_of RPN, rpn
  end

  # UNIT TESTS FOR METHOD print_result(result)
  # Equivalence classes: n/a

  # This test case checks that printing an integer actually prints to the console
  def test_print
    var = 30
    assert_kind_of Integer, var
    assert_output(var)
  end

  # UNIT TESTS FOR METHOD self.numeric?(look_ahead)
  # Equivalence classes:
  # look_ahead is not a number -> returns nil
  # look_ahead is a number -> returns the index of the last number found

  #
  def test_numeric_positive
    test_value = RPN.numeric?(6)
    assert_equal(test_value,0)
  end

  def test_numeric_negative
    test_value = RPN.numeric?(-6)
    assert_equal(test_value,0)
  end

  def test_numeric_not_number
    test_value = RPN.numeric?('a')
    assert_equal(test_value,nil)
  end

  # UNIT TESTS FOR METHOD self.letter?(look_ahead)
  # Equivalence classes:
  # look_ahead is not a alphabet letter -> returns nil
  # look_ahead is an alphabet letter -> returns the index of the last letter found

  def test_letter
    test_value = RPN.letter?('a')
    assert_equal(test_value,0)
  end

  def test_not_letter
    test_value = RPN.letter?('6')
    assert_equal(test_value,nil)
  end

  # UNIT TESTS FOR METHOD self.symbol?(look_ahead)
  # Equivalence classes:
  # look_ahead is not an operator symbol -> returns nil
  # look_ahead is an operator symbol -> returns the index of the last symbol found

  def test_negative_symbol
    test_value = RPN.symbol?('-')
    assert_equal(test_value,0)
  end

  def test_divide_symbol
    test_value = RPN.letter?('/')
    assert_equal(test_value,0)
  end

  # UNIT TESTS FOR METHOD check_let(keyword)
  # Equivalence classes:
  # keyword = 'LET' (case-insensitive) -> returns true
  # keyword != 'LET' (case-insensitive) -> return false

  # Create a string with mixed upper- and lower-case letters, verify that the downcase method makes all the letters lower-case
  def test_downcase_string
    test = 'MiXeD'
    down = test.downcase
    assert_equal down, 'mixed'
  end

  # Create a new RPN, verify that LET can be case-insensitive, and verify that check_let returns true on valid input
  def test_check_let
    RPN rpn = RPN.new(1)
    let = 'let'
    assert_equal let, 'let'
    assert rpn.check_let(let)
  end

  # Create a new RPN and verify that check_let will return false with incorrect input
  def test_not_let
    RPN rpn = RPN.new(2)
    let = 'foo'
    refute_equal let, 'let'
    refute rpn.check_let(let)
  end

  # UNIT TESTS FOR METHOD check_print(keyword)
  # Equivalence classes:
  # keyword = 'PRINT' (case-insensitive) -> returns true
  # keyword != 'PRINT' (case-insensitive) -> return false

  # Create a new RPN and verify that check_print returns true on valid input
  def test_check_print
    RPN rpn = RPN.new(2)
    print = 'print'
    assert_equal print, 'print'
    assert rpn.check_print(print)
  end

  # Create a new RPN and verify that check_print will return false with incorrect input
  def test_not_print
    RPN rpn = RPN.new(2)
    print = 'leT'
    refute_equal let.downcase, 'print'
    refute rpn.check_print(print)
  end

  # UNIT TESTS FOR METHOD quit(quit_keyword)
  # quit_keyword = 'QUIT' (case-insensitive) -> exit
  # quit_keyword != 'QUIT' (case-insensitive) -> do nothing

  # Create a new RPN and verify that quit exits on valid input
  def test_quit
    RPN rpn = RPN.new(1)
    quit = 'QUIT'
    assert_equal quit, 'quit'
    assert_respond_to rpn.quit(quit), exit
  end

  # Create a new RPN and verify that quit will not exit with incorrect input
  def test_not_quit
    RPN rpn = RPN.new(1)
    quit = 'laboon'
    refute_equal quit, 'quit'
    assert_silent() { sim.quit(quit) }
  end

  # UNIT TESTS FOR METHOD write_let(letter, number)
  # Equivalence classes:
  # letter is not a valid letter -> return false
  # letter is a valid letter -> hash letter to number in an array

  # Create a letter and verify that the system treats it as a letter
  def test_is_a_letter
    assert_equal true, RPN.letter?('c').zero?
    refute_equal true, RPN.letter?('$').zero?
  end

  def test_write_value
    letters = ['a', 'b', 'c']
    array = Hash[letters.map { |x| [x, nil] }]
    array['a'] = 5
    assert_equal array['a'], 5
  end

  # UNIT TESTS FOR METHOD self.symbol_calculate(symbol, operand1, operand2)
  # Equivalence classes:
  # symbol = '+' -> operand2 + operand1
  # symbol = '-' -> operand2 - operand1
  # symbol = '*' -> operand2 * operand1
  # symbol = '/' -> operand2 / operand1

  def test_symbol_calculate_plus
    operand1 = 10
    operand2 = -3
    sum = operand1 + operand2
    assert_equal true, RPN.symbol?('+').zero?
    assert_equal 7, sum
  end

  def test_symbol_calculate_minus
    operand1 = 20
    operand2 = -6
    difference = operand1 - operand2
    assert_equal true, RPN.symbol?('-').zero?
    assert_equal 26, difference
  end

  def test_symbol_calculate_multi
    operand1 = 30
    operand2 = 2
    product = operand1 + operand2
    assert_equal true, RPN.symbol?('*').zero?
    assert_equal 60, product
  end

  def test_symbol_calculate_divide
    operand1 = 30
    operand2 = -6
    product = operand1 + operand2
    assert_equal true, RPN.symbol?('/').zero?
    assert_equal -5, product
  end

  # TEST 17
  # UNIT TESTS FOR METHOD calculate_postfix_expression(expression)
  # SUCCESS CASES: The expression is valid and the arithmetic is correct
  # FAILURE CASES: If the expression is invalid in any way, or the arithmetic is incorrect

  def test_calculate_postfix_numbers
    RPN rpn = RPN.new(2)
    expression = '1 2 +'
    assert_equal rpn.calculate_postfix_expression(expression), 3
  end

  def test_calculate_postfix_variables
    RPN rpn = RPN.new(2)
    rpn.write_let('a', 2)
    rpn.write_let('b', 3)
    expression = 'a b +'
    assert_equal rpn.calculate_postfix_expression(expression), 5
  end

  def test_calculate_postfix_large_integer
    RPN rpn = RPN.new(2)
    expression = '9999999999999 99999999999 +'
    assert_equal rpn.calculate_postfix_expression(expression), 10099999999998
  end

  def test_calculate_postfix_mix
    RPN rpn = RPN.new(2)
    rpn.write_let('a', 2)
    expression = 'a 2 +'
    assert_equal rpn.calculate_postfix_expression(expression), 4
  end

  # UNIT TESTS FOR METHOD rpn_driver(user_input, keyword, rpn)
  # SUCCESS CASES: The user_input, keyword, and rpn are valid
  # FAILURE CASES: None of the arguments are valid or the driver doesn't handle the arithmetic

  def test_user_input_driver_print_valid

  end

  def test_user_input_driver_print_invalid

  end

  def test_user_input_driver_let_valid

  end

  def test_user_input_driver_let_invalid

  end

  def test_user_input_driver_empty

  end

  def test_user_input_driver_repl_mode

  end

end
