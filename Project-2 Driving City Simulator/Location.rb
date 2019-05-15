class Location

  def initialize(loc_name,loc_id,street_array)
    @loc_id = loc_id
    @loc_name = loc_name
    @street_array = street_array
  end

  def get_location_id
    return @loc_id
  end

  def get_location
    return @loc_name
  end

  def get_street_array
    return @street_array
  end
end
