class Rule

  def initialize(rule_type, cond = {})
    @rule_type = rule_type
    @cond = cond
  end

  def eligible_for?(items_or_balance)
    case @rule_type
    when :total
      items_or_balance.send(@cond[:comparison], @cond[:threshold])
    when :price_drop
      item = @cond[:item]
      items_or_balance[item][:qty] >= @cond[:qty]
    else
      raise ArgumentError.new('Undefined rule type.') 
    end
  end

  def apply_to(items_or_balance)
    case @rule_type
    when :total
      if @cond[:discount].include?('%')
        items_or_balance * (1 - @cond[:discount].to_f / 100)
      else
        items_or_balance - @cond[:discount].to_f
      end
    when :price_drop
      item = @cond[:item]
      items_or_balance[item][:price] = @cond[:drop_to]
    else
      raise ArgumentError.new('Undefined rule type.') 
    end
  end
end