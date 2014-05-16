class Rule

  attr_reader :requires

  def initialize(discount, requires = {})
    @discount = discount
    @requires = requires
  end

  def eligible?(given_data)
    if @requires[:total] and given_data.is_a? Float
      return given_data >= @requires[:amount]
    elsif @requires[:each] and given_data.is_a? Hash
      @requires[:items].each do |item, qty|
        return false if given_data[item] < qty
      end
    else
      return false
    end
  end

  # This method is to apply the discount to the total revenue or to individuals
  def apply(given_data)
    if @requires[:total]
      if @requires[:percent]
        return given_data * (1 - @discount.to_f / 100)
      else
        return given_data - @discount
      end
    else
      revenue = 0
      @requires[:items].each do |item, qty|
        revenue += @discount * qty
        given_data[item] = given_data[item] - qty
      end
      return revenue, given_data
    end
  end
end
