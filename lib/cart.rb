class Cart
  attr_reader :items

  def initialize
    @items = Hash.new
  end

  def scan(item)
    @items[item] ? @items[item] += 1 : @items[item] = 1
  end

  def [](key)
    @items[key]
  end

  def balance
    return @balance if @balance
    @balance = @items.inject(0) { |sum, (k, v)| sum + items_info[k][:price] * v }
  end

  def balance=(balance)
    @balance = balance
  end

  private

  def items_info
    {
      "001" => { price: 9.25,  name: "Lavender heart" },
      "002" => { price: 45.00, name: "Personalised cufflinks" },
      "003" => { price: 19.95, name: "Kids T-shirt" }
    }
  end
end