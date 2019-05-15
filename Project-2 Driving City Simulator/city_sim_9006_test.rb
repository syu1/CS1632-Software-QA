require "minitest/autorun"
require_relative "city_sim_9006"
class CitySim9006Test < Minitest::Test
  def setup
    @city = CitySim9006.new
  end
  # UNIT TESTS FOR METHOD populate_drivers()
  # NO Equivalence partition
  # populate_drivers always is filled the same with the same parameters
  # check that something is populated


  def test_populate_drivers
    assert_equal @city.populate_drivers!= nil
  end
  # UNIT TESTS FOR METHOD populate_locations()
  # NO Equivalence partition
  # populate_locations always is filled the same with the same parameters

  # If a negative value is given for x, then a random seed is generated using that value.
  def test_populate_locations
    assert_equal @city.populate_locations!= nil
  end
  # UNIT TESTS FOR METHOD print_movement


  def test_print_movement
    assert_equal @city.print_movment("Driver 1","Hospital","Hillman","Foo")!= nil
  end
  # UNIT TESTS FOR METHOD update_collectables
  # Equivalence classes
  # x= 1 ->  double classes
  # x= 2 -> adds 1 book
  # x= 3 -> adds 1 toy
  # STUDBBED

  # If a 1 value is given for x, then update classes
  def test_update_collectables
    driver = Driver.new("Driver 1",0,0,1,rand(0..3))
    id = 1
    assert_equal driver.get_books = 1, @city.update_collectables(id,driver)
  end
  # If a 2 value is given for x, then update toys
  def test_update_collectables
    driver = Driver.new("Driver 1",0,0,1,rand(0..3))
    id = 2
    assert_equal driver.get_books = 1, @city.update_collectables(id,driver)
  end
  # If a 3 value is given for x, then update classes
  def test_update_collectables
    driver = Driver.new("Driver 1",0,0,1,rand(0..3))
    id = 3
    assert_equal driver.get_books = 2, @city.update_collectables(id,driver)
  end
  # UNIT TESTS FOR METHOD print_collectables
  # NO Equivalence partition
  # test print always is filled the same with the same parameters
  # STUBBED

  def test_print_collectables
    driver = Driver.new("Driver 1",0,0,1,rand(0..3))
    assert_equal @city.print_collectables("Driver 1",driver)!= nil
  end
  # UNIT TESTS FOR METHOD input()
  # Equivalence classes:
  # x= -214483648..-1 -> returns srand(-x)
  # x= 0..214483647 -> returns srand(-x)
  # x= x < -214483648 || x > 214483647 -> returns srand(0)
  # x= (not a number) -> returns srand(0)

  # If a negative value is given for x, then a random seed is generated using that value.
  def test_negative_input
    test_input = -1
    assert_equal srand(test_input), @city.input(test_input)
  end

  # If a positive value is given for x, then a random seed is generated using that value.
  def test_positive_input
    test_input = 1
    assert_equal srand(test_input), @city.input(test_input)
  end

  # If a Integer overflow value is given for x, then the seed 0 is used for that value.
  # EDGE CASE
  # STUDBBED
  def test_overflow_input
    test_input = 2147483649
    assert_equal srand(0), @city.input(test_input)
  end

  # If an invalid value, such as a string, is given for x,
  # then 0 is used as the seed.
  # EDGE CASE
  # STUBBED
  def test_invalid_val_input
    assert_equals srand(0), @city.input("poodle")
  end
  # UNIT TESTS FOR METHOD run()
  # Logic that the drivers run
  def test_run
      assert_equal @city.run()!= nil
  end

end
