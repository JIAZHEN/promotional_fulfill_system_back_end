require_relative 'math_helper'
class Item

	attr_accessor :product_code, :price, :quantity

	def initialize(product_code, price, quantity)
		raise ArgumentError, 'ProductCode is not String' unless product_code.is_a? String
		raise ArgumentError, 'Price is not Numeric' unless price.is_a? Numeric
		raise ArgumentError, 'Quantity is not Numeric' unless quantity.is_a? Numeric

		@math_helper = MathHelper.new
		
		#convert all product_code to downcase
		@product_code = product_code.downcase
		@price = price
		@quantity = quantity
		
	end

	def total
		@math_helper.round(@price * @quantity)
	end

	def ==(another_sock)
	    self.product_code == another_sock.product_code && 
	    self.price 		  == another_sock.price 	   &&
	    self.quantity 	  == another_sock.quantity
	end
end