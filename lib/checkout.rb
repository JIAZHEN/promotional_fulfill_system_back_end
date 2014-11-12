require 'bigdecimal'
require 'cart'
require 'forwardable'

class Checkout
  extend Forwardable

  attr_reader :cart

  def initialize(*rules)
    @cart = Cart.new
    @rules = Array(rules)
  end

  def total
    return @cart.balance if @rules.empty?
    benefit = @rules.inject(0) { |sum, rule| rule.items? ? (sum + rule.total(@cart)) : sum  }
    @cart.balance = @cart.balance + benefit if benefit
    satisfied_rule = @rules.find { |rule| rule.balance? && rule.match?(@cart) }
    round(satisfied_rule ? satisfied_rule.total(@cart) : @cart.balance)
  end

  def_delegator :@cart, :scan, :scan

  private

  def round(value, precision = 2)
    bd = BigDecimal(value.to_s)
    bd.round(precision, BigDecimal::ROUND_HALF_UP).to_f
  end
end
