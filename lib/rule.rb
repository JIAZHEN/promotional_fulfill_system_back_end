class Rule

  def initialize(rule_type, cond = {})
    @rule_type = rule_type
    @cond = cond
  end

  def eligible_for?(given_data)
    case @rule_type
    when :total
      given_data.send(@cond[:comparison], @cond[:threshold])
    else
      raise ArgumentError.new('Undefined rule type.') 
    end
  end

  # This method is to apply the discount to the total revenue or to individuals
  def apply(given_data)
    if @cond[:total]
      if @cond[:percent]
        return given_data * (1 - @discount.to_f / 100)
      else
        return given_data - @discount
      end
    else
      revenue = 0
      @cond[:items].each do |item, qty|
        revenue += @discount * qty
        given_data[item] = given_data[item] - qty
      end
      return revenue, given_data
    end
  end
end
