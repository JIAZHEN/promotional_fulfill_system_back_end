require 'bigdecimal'
# This is the class to fulfil the back end of checkout system

class Checkout

  attr_reader   :items

  def initialize(*rules)
    @items = Hash.new
    split_rules(rules)
  end

  def scan(item)
    if @items[item]
      @items[item][:qty] += 1
    else
      @items[item] = { qty: 1, price: items_price[item][:price] }
    end
  end

  def total
    revenue = 0
    @other_rules.each { |rule| rule.apply_to(@items) if rule.eligible_for?(@items) }
    @items.values.each { |item_info| revenue += item_info[:price] * item_info[:qty] }
    @total_rules.each { |rule| revenue = rule.apply_to(revenue.to_f) if rule.eligible_for?(revenue.to_f) } 
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

  def split_rules(rules)
    @total_rules, @other_rules = Set.new, Set.new
    rules.each { |rule| rule.is_for_total? ? (@total_rules << rule) : (@other_rules << rule) }
  end
end
