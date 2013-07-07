require_relative 'math_helper'

# This is a class to store item information
class Item

	attr_reader		:product_code
	attr_accessor	:price, :quantity

	# All arguments are required, 
	# product code must be string, price and quantity must be numeric
	def initialize(product_code, price, quantity)
		raise ArgumentError, 'ProductCode is not String' unless product_code.is_a? String
		raise ArgumentError, 'Price is not Numeric' unless price.is_a? Numeric
		raise ArgumentError, 'Quantity is not Numeric' unless quantity.is_a? Numeric
		
		#convert all product_code to downcase
		@product_code = product_code.downcase
		@price = price
		@quantity = quantity
		
	end

	# This method will calculate the renvenue by using price multiply quantity
	# by default it rounds the result with 2 digits after decimal point
	def total(precision = 2)
		MathHelper.round(@price * @quantity, precision)
	end

	def ==(another_sock)
	    self.product_code == another_sock.product_code && 
	    self.price 		  == another_sock.price 	   &&
	    self.quantity 	  == another_sock.quantity
	end
end