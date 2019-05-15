class Driver
  def initialize(name,books,toys,classes,location)
    @name = name
    @books = books
    @toys = toys
    @location = location
    @classes = classes
  end

  def get_name
    return @name
  end

  def get_books
    return @books
  end

  def get_toys
    return @toys
  end

  def get_location_id
    return @location
  end

  def get_class
    return @classes
  end

  def update_location(new_location)
    @location = new_location
  end

  def update_toys
    @toys+=1
  end

  def update_books
    @books+=1
  end

  def update_class
    @classes = @classes*2
  end
end
