class Person
  def initialize(name, coin_amount)
    @name = name
    @coin_amount = coin_amount

  end

  def get_name
    @name
  end

  def coin_amount
    @coin_amount
  end

  def add(add_amount)
    @coin_amount += add_amount
  end

  def subtract(subtract_amount)
    @coin_amount -= subtract_amount
  end
end
