#The Verifier by Sam Yu and Mufaro Nyereyemhuka
require_relative "Person"
#require 'flamegraph'

class Verifier

  #initialize stuff
  $current_file
  $line_array
  $current_line_split

  # Variables for checking if the block numbers match
  $block_number

  #Variables for checking if hashes match
  $hash_of_previous # the previous blocks actual hash value
  $reference_previous_hash #the current blocks reference for the previous blocks hash value

  # Variables for processing transactions
  $block_transactions
  $person_array = Array.new

  # Variables for checking the epoch times
  $epoch_time   #time since creation
  $current_seconds
  $current_nano
  $previous_seconds
  $previous_nano

  $new_hash

  #take cmd input and check for incorrect input

  def read_file(file_name)
    if file_name == nil
      puts "FILE IS NIL"
      puts "SYSTEM EXIT"
      return false

    else
      $current_file = file_name
      return true
    end

  end

  def read_line(file_name2)
    if file_name2 == nil
      puts "FILE IS NIL"
      puts "SYSTEM EXIT"
      return false
    else
      $line_array = IO.readlines(file_name2)
      return true
    end

  end

  def parse_line(line)
    $current_line_split = line.split("|") #PIPE DELIMITER
    $block_number = $current_line_split[0]
    $reference_previous_hash = $current_line_split[1]
    $block_transactions = $current_line_split[2]
    $epoch_time = $current_line_split[3]
    $current_seconds = $epoch_time.to_s.split(".").first
    $current_nano = $epoch_time.to_s.split(".").last
    $new_hash = $current_line_split[4]
  end

  def check_block_number(counter)

    if $block_number.to_i != counter
      print "Line " + counter.to_s + ": Invalid block number " + $block_number + ", "
      puts "should be " + counter.to_s
      puts "BLOCKCHAIN INVALID"
      return false
    else
      return true
    end
  end

  def check_initial_hash_reference(value)
    if value.to_s != "0"
      puts "Line " + $block_number.to_s + ": Previous hash was " + value.to_s + ", should be 0"
      puts "BLOCKCHAIN INVALID"
      return false

    else
      return true
    end
  end

  def check_hash_match(previous_value, current_value)
    add_line = current_value + "\n"
    if add_line != previous_value
      puts "Line " + $block_number.to_s + ": Previous hash was " + current_value.to_s + ", should be " + previous_value.to_s
      puts "BLOCKCHAIN INVALID"
      return false
    else
      return true
    end

  end

  def check_initial_transaction(transactions)
    # takes in an array of transactions
    # checks that the length of the array is one
    if transactions.length != 1
      puts "Line " + $block_number.to_s + ": First block does not have only one transaction!"
      puts "BLOCKCHAIN INVALID"
      return false
    else
      return true
    end
  end

  def set_initial_transaction(first_transaction)
    # adds a person to the $person_array
    persons = first_transaction.split(">")
    sender = persons[0]
    string2 = persons[1]
    index1 = string2.index("(")
    receiver = string2[0,index1]

    index2 = string2.index(")")
    str_length = string2.length - index1 - 2
    coin_amount = string2[index1+1,str_length]

    new_person = Person.new(receiver, coin_amount.to_i)
    $person_array << new_person

  end

  def split_transactions(block_trans)
    # takes in a block's transactions and returns a split-array of transactions
    split_trans = block_trans.split(":")
  end

  def process_transaction(split_transaction)
    # takes in a transaction and processes it via the sender, receiver, and coin amount
    persons = split_transaction.split(">")
    sender = persons[0]
    string2 = persons[1]
    index1 = string2.index("(")
    receiver = string2[0,index1]

    index2 = string2.index(")")
    str_length = string2.length - index1 - 2
    coin_amount = string2[index1+1,str_length]
    in_array = false

    for person in $person_array
      if sender == person.get_name && sender != receiver
        person.subtract coin_amount.to_i
      elsif receiver == person.get_name && sender != receiver
        person.add coin_amount.to_i
        in_array = true
      end
    end

    if !in_array && sender != receiver
      new_person = Person.new(receiver, coin_amount.to_i)
      $person_array << new_person
    end

  end

  def check_last_transaction(transactions)
    # takes in an array of transactions
    # checks that the last transaction is from the system to a user

    last_transaction = transactions[transactions.length-1]
    persons = last_transaction.split(">")
    sender = persons[0]

    if sender != "SYSTEM"
      puts "Line " + $block_number.to_s + ": The last transaction is not from the SYSTEM!"
      puts "BLOCKCHAIN INVALID"
      return false
    else
      return true
    end

  end

  def check_coin_amounts(array, line_num)
    # checks if all of the people have 0 or more coins at the end of the block
    return_val = true
    array.each do |person|

      if person.coin_amount < 0
        #return_val = -1
        puts "Line " + line_num.to_s + ": Invalid block, address " + person.get_name + " has " + person.coin_amount.to_s + " billcoins!"
        puts "BLOCKCHAIN INVALID"
        return_val = false
      end
    end
    return return_val
  end

  def check_valid_epoch(seconds, nanoseconds)
    # checks max-int epoch
    # checks greater than zero

    int_seconds = seconds.to_s.to_i
    int_nano = nanoseconds.to_s.to_i

    if int_seconds < 0 || int_nano < 0 || (int_seconds == 00 && int_nano == 0)
      puts "Line " + $block_number.to_s + ": Invalid epoch time"
      puts "BLOCKCHAIN INVALID"
      return false
    else
      return true
    end

  end

  def check_epoch_times(previous_s, previous_n, current_s, current_n)

    if previous_s.to_i > current_s.to_i || (previous_s.to_i == current_s.to_i && previous_n.to_i >= current_n.to_i)
      print "Line " + $block_number.to_s + ": Previous timestamp "
      print previous_s.to_s + "." + previous_n + " >= new timestamp "
      puts $epoch_time.to_s
      puts "BLOCKCHAIN INVALID"
      return false

    else
      return true
    end
  end

  def compute_hash(block,prev_hash,trans,epoch)
    array_chars = Array.new
    value_hash = 0

    string_hash = "#{block}|#{prev_hash}|#{trans}|#{epoch}"
    array_chars = (string_hash.unpack('U*'))

    array_chars.map! do |x|
      (x ** 2000) * ((x + 2) ** 21) - ((x + 5) ** 3)
    end
    value_hash = array_chars.inject(0){|sum,x| sum + x }

    value_hash = value_hash % 65536
    return value_hash.to_s(16)
  end

  def check_computed_hash(current_hash)
    computed_hash = compute_hash($block_number,$reference_previous_hash,$block_transactions,$epoch_time)
    check_hash_match(current_hash,computed_hash)

  end

end # end class Verifier

# EXECUTION STARTS HERE

#FlameGraph.generate('flamegraph.html') do
my_verifier = Verifier.new
exit_file = my_verifier.read_file(ARGV.first())
if exit_file == false
  exit
end


my_verifier.read_line($current_file)
exit_block_number = true
exit_intial_hash_reference = true
exit_computed_hash = true
exit_epoch_times = true
exit_hash_match = true

counter = 0

# For-each loop for checking that each block is valid in the block chain
$line_array.each do |line|
  my_verifier.parse_line line
  split_transactions = my_verifier.split_transactions $block_transactions

  if counter == 0

    exit_block_number = my_verifier.check_block_number counter
    if exit_block_number == false
      exit
    end

    exit_intial_hash_reference = my_verifier.check_initial_hash_reference $reference_previous_hash
    if exit_intial_hash_reference == false
      exit
    end

    exit_initial_transaction = my_verifier.check_initial_transaction split_transactions

    if exit_initial_transaction == false
      exit
    end

    exit_last_transaction = my_verifier.check_last_transaction split_transactions

    if exit_last_transaction == false
      exit
    end

    my_verifier.set_initial_transaction split_transactions[0]

    my_verifier.check_valid_epoch $current_seconds, $current_nano

    exit_computed_hash = my_verifier.check_computed_hash($new_hash)
    if exit_computed_hash == false
      exit
    end

    $hash_of_previous = $new_hash
    $previous_seconds = $current_seconds
    $previous_nano = $current_nano

  else

    exit_block_number = my_verifier.check_block_number counter

    if exit_block_number == false
      exit
    end

    exit_hash_match = my_verifier.check_hash_match $hash_of_previous, $reference_previous_hash
    if exit_hash_match == false
      exit
    end

    split_transactions.each do |transaction|
      my_verifier.process_transaction transaction
    end

    exit_last_transaction = my_verifier.check_last_transaction split_transactions

    if exit_last_transaction == false
      exit
    end

    exit_coin_amounts =  my_verifier.check_coin_amounts $person_array, $block_number

    if exit_coin_amounts == false
      exit
    end

    exit_epoch_times = my_verifier.check_epoch_times $previous_seconds, $previous_nano, $current_seconds, $current_nano
    if exit_epoch_times == false
      exit
    end

    exit_computed_hash = my_verifier.check_computed_hash($new_hash)

    if exit_computed_hash == false
      exit
    end

    $hash_of_previous = $new_hash
    $previous_seconds = $current_seconds
    $previous_nano = $current_nano
  end

  counter += 1

end # end for-each loop

$person_array.each do |person|
  puts person.get_name + ": " + person.coin_amount.to_s + " billcoins"
end

#end # end FlameGraph
