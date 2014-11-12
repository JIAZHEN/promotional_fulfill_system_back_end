class Rule
  KEYS = [:items, :balance]

  def initialize(options = {}, &block)
    KEYS.each do |key|
      instance_variable_set("@#{key}", options[key]) if options[key]
      self.class.send(:define_method, key) { instance_variable_get("@#{key}") }
      self.class.send(:define_method, "#{key}?".to_sym) { !self.public_send(key).nil? }
    end
    @calculator = block
  end

  def match?(cart)
    (items.nil? || items.all?{|item,qty| cart[item] >= qty}) &&
    (balance.nil? || balance.all?{|sym, v| cart.balance.send(sym, v)})
  end

  def total(cart)
    match?(cart) ? @calculator.call(cart) : 0
  end
end
