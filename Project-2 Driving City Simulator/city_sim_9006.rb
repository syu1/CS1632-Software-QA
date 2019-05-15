require_relative "Location"
require_relative "Street"
require_relative "Driver"

class CitySim9006
  #initialize stuff
  $drivers
  $locations
  $random
  def populate_drivers()
    driver1 = Driver.new("Driver 1",0,0,1,rand(0..3))
    driver2 = Driver.new("Driver 2",0,0,1,rand(0..3))
    driver3 = Driver.new("Driver 3",0,0,1,rand(0..3))
    driver4 = Driver.new("Driver 4",0,0,1,rand(0..3))
    driver5 = Driver.new("Driver 5",0,0,1,rand(0..3))
    $drivers = [driver1,driver2,driver3,driver4,driver5]
  end


  def populate_locations()
    hospital_streets = [Street.new("Foo St.","Hillman"),Street.new("Fourth Ave.", "Cathedral")]
    cathy_streets = [Street.new("Bar St.","Museum"),Street.new("Fourth Ave.", "Monroeville")]
    hillman_streets = [Street.new("Foo St.","Hospital"),Street.new("Fifth Ave.", "Downtown")]
    museum_streets = [Street.new("Bar St.","Cathedral"),Street.new("Fifth Ave.", "Hillman")]

    hospital = Location.new("Hospital",0,hospital_streets)
    cathy = Location.new("Cathedral",1,cathy_streets)
    hillman = Location.new("Hillman",2,hillman_streets)
    museum  = Location.new("Museum",3,museum_streets)
    monroeville = Location.new("Monroeville",4,nil)
    downtown = Location.new("Downtown",5,nil)
    $locations = [hospital,cathy,hillman,museum,monroeville,downtown]

  end
#take cmd input and check for incorrect input
  def input(input)
    if input.length > 1 || input.length == 0
      abort("Enter a seed and only a seed (Runtime Error)")
      exit!
    end
    result = Integer(input[0]) rescue false
    if result == false
      $random = srand(0)
    elsif input[0].to_f <= -214483648 || input[0].to_f >= 2147483647
      $random = srand(0)
    else
      seed = input[0].to_i
      $random = srand(seed)
    end
  end

#Logic for looping through the driver movments
  def run()
    for driver in $drivers
      while driver.get_location_id != 4 || 5
        current_driver = driver
        current_driver_name = current_driver.get_name
        current_location_id = current_driver.get_location_id

        update_collectables(current_location_id,current_driver)

        current_location = $locations[current_location_id]
        current_location_name = $locations[current_location_id].get_location

        if current_location.get_street_array == nil
          print_collectables(current_driver_name,current_driver)
          break
        end

        new_random_location = rand(0..1)

        street = current_location.get_street_array[new_random_location].get_street_name
        destination = current_location.get_street_array[new_random_location].get_move

        print_movement(current_driver_name,current_location_name,destination,street)

        new_location = nil
        $locations.each do |location|
          if destination == location.get_location
            new_location = location.get_location_id
          end
        end
        current_driver.update_location(new_location)

      end
    end
  end
  #prints out the movement of the current driver
  def print_movement(name,location,destination,street)
    puts name +" heading from " + location +" to "+destination+" via "+street
  end

  #update toys, books and classes of the driver
  def update_collectables(current_location_id,current_driver)
    if current_location_id == 1
      current_driver.update_class
    elsif current_location_id ==2
      current_driver.update_books
    elsif  current_location_id ==3
      current_driver.update_toys
    end
  end
  #print out the collectables
  def print_collectables(current_driver_name,current_driver)
    puts current_driver_name + " obtained "+ current_driver.get_books.to_s + " books!"
    puts current_driver_name + " obtained "+ current_driver.get_toys.to_s + " dinosaur toys!"
    puts current_driver_name + " attended "+ current_driver.get_class.to_s + " class!"
  end

end

#execute
new_city = CitySim9006.new
new_city.input(ARGV)
new_city.populate_drivers
new_city.populate_locations
new_city.run
