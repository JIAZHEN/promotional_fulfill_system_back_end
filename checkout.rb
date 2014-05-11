require 'bigdecimal'
# This is the class to fulfil the back end of checkout system

class Checkout

  attr_reader   :items

  def initialize(rules = Hash.new)
    @rules = rules
    @items = Hash.new
  end

  def scan(item)
    if @items[item]
      @items[item] += 1
    else
      @items[item] = 1
    end
  end

  def total(items_info)
    revenue = 0
    # check the rules for individuals first
    @rules.each do |rule|
      if rule.eligible? @items
        per_total, items = rule.apply @items
        revenue += per_total
        @items = items
      end
    end

    @items.each { |item, qty| revenue += items_info[item][:price] * qty }
    # now we check the rules for overall
    @rules.each { |rule| revenue = rule.apply revenue.to_f if rule.eligible? revenue.to_f } 
    return round(revenue)
  end

  private
  def round(value, precision = 2)
    bd = BigDecimal(value.to_s)
    bd.round(precision, BigDecimal::ROUND_HALF_UP).to_f
  end
end
