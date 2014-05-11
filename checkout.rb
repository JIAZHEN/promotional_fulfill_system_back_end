require 'bigdecimal'
# This is the class to fulfil the back end of checkout system

class Checkout

  attr_reader   :items

  def initialize(rules = Array.new)
    @rules = rules
    @items = Hash.new
  end

  def scan(item)
    @items[item] ? (@items[item] += 1) : @items[item] = 1
  end

  def total
    revenue = 0
    @rules.each do |rule|
      if rule.eligible? @items
        per_total, items = rule.apply @items
        revenue += per_total
        @items = items
      end
    end

    @items.each { |item, qty| revenue += items_price[item][:price] * qty }
    # now we check the rules for overall
    @rules.each { |rule| revenue = rule.apply revenue.to_f if rule.eligible? revenue.to_f } 
    return round(revenue)
  end

  def items_price
    { 
      "001" => { price: 9.25,  name: "Lavender heart" },
      "002" => { price: 45.00, name: "Personalised cufflinks" },
      "003" => { price: 19.95, name: "Kids T-shirt" } 
    }
  end

  private
  def round(value, precision = 2)
    bd = BigDecimal(value.to_s)
    bd.round(precision, BigDecimal::ROUND_HALF_UP).to_f
  end
end
