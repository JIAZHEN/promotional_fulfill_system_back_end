class Item

	attr_accessor :product_code, :price, :quantity

	def initialize(product_code, price, quantity)
		raise ArgumentError, 'ProductCode is not String' unless product_code.is_a? String
		raise ArgumentError, 'Price is not Numeric' unless price.is_a? Numeric
		raise ArgumentError, 'Quantity is not Numeric' unless quantity.is_a? Numeric

		#convert all product_code to downcase
		@product_code = product_code.downcase!
		@price = price
		@quantity = quantity
	end

	def total
		@price * @quantity
	end
end