
require 'minitest/autorun'
require_relative 'Verifier'
require_relative 'Person'

class TestVerifier < Minitest::Test
  #setup

  line1 = "13|ad78|SYSTEM>James(100)|1518893696.799132000|5e6e"
  line2 = "14|5e6e|Louis>Louis(4):SYSTEM>Edward(100)|1518893696.803320000|63ac"

  $current_file = ARGV[0]
  $line_array

  $old_line_split = line1.split("|") #PIPE DELIMITER
  $old_block_number = $old_line_split[0]
  $old_previous_hash = $old_line_split[1]
  $old_transactions = $old_line_split[2]
  $old_epoch_time = $old_line_split[3]
  $old_seconds = $old_time.to_s.split(".").first
  $old_nano = $old_time.to_s.split(".").last
  $old_new_hash = $old_line_split[4]

  $current_line_split = line2.split("|") #PIPE DELIMITER
  $block_number = $current_line_split[0]
  $reference_previous_hash = $current_line_split[1]
  $transactions = $current_line_split[2]
  $epoch_time = $current_line_split[3]
  $current_seconds = $epoch_time.to_s.split(".").first
  $current_nano = $epoch_time.to_s.split(".").last
  $new_hash = $current_line_split[4]

  #expects a correct counter
  # returns true if counter is not accurate
  # returns false if counter is accurate
  def test_check_block_number_correct
    ver = Verifier.new

    counter = 14
    #tests if check block passes all checks
    assert_equal(ver.check_block_number(counter),true)
  end

  #expects incorrect counter and checks boundarys
  # returns true if counter is not accurate
  # returns false if counter is accurate
  def test_check_block_number_wrong
    ver = Verifier.new

    #tests if check block passes all checks
    assert_equal(ver.check_block_number(-1),false)
    assert_equal(ver.check_block_number(0),false)
    assert_equal(ver.check_block_number(13),false)
    assert_equal(ver.check_block_number(15),false)
  end
  #expects that the intial hash reference is zero
  # returns true if hash is zero
  # returns false otherwise
  def test_check_initial_hash_reference_zero_correct
    ver = Verifier.new

    assert_equal(ver.check_initial_hash_reference(0),true)
  end

  #expects incorrect values and checks boundarys
  # returns true if hash reference is zero
  # false otherwise
  def test_check_initial_hash_reference_wrong
    ver = Verifier.new

    assert_equal(ver.check_initial_hash_reference(1),false)
    assert_equal(ver.check_initial_hash_reference(-1),false)
    assert_equal(ver.check_initial_hash_reference(1000),false)
  end
  #expects viable epoch values checks boundarys for viable values
  # returns true if viable epoch
  # false otherwise
  def test_valid_epoch_right
    ver = Verifier.new

    assert_equal(ver.check_valid_epoch(100,0),true)
    assert_equal(ver.check_valid_epoch(0,100),true)
    assert_equal(ver.check_valid_epoch(100,1000),true)
  end

  #expects nonviable epoch times for boundary values
  # returns true if viable epoch
  # false otherwise
  def test_valid_epoch_wrong
    ver = Verifier.new
    assert_equal(ver.check_valid_epoch(-1,0),false)
    assert_equal(ver.check_valid_epoch(0,-1),false)
    assert_equal(ver.check_valid_epoch(-1,-1),false)
  end
  #expects correct hash value
  # returns hash value

  def test_compute_hash_correct
    ver = Verifier.new
    assert_equal(ver.compute_hash($block_number,$reference_previous_hash,$transactions,$epoch_time),$new_hash)

  end
  #expects incorrect hash value
  # returns incorrect hash value
  def test_compute_hash_incorrect
    ver = Verifier.new

    refute_equal(ver.compute_hash($block_number,$reference_previous_hash,$transactions,$epoch_time),"23d2")
  end
  #expects correct filetype
  # returns true if correct filetype
  # false otherwise

  def test_vaild_file_type
  ver = Verifier.new
  assert_equal(ver.read_file(ARGV[0]),true)

  end
  #expects incorrect filetype
  # returns true if correct filetype
  # false otherwise
  def test_not_file_type
    ver = Verifier.new
    refute_equal(ver.read_file(ARGV[0]),false)
  end


  def test_valid_line_read
    ver = Verifier.new
    assert_equal(ver.read_line($current_file),true)
  end

  def test_invalid_line_read
    ver = Verifier.new
    refute_equal(ver.read_line($current_file),false)
  end

end
