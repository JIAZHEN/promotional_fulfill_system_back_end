require_relative 'math_helper'

class PromotionalRule

	attr_reader :requires

	def initialize(discount, requires = {})
		@discount = discount
		@requires = requires
	end

	def eligible?(given_data)
		if @requires[:total] and given_data.is_a? Float
			return given_data >= @requires[:amount]
		elsif @requires[:each] and given_data.is_a? Array
			@requires[:items].each do |item, qty|
				return false if given_data[item] < qty
			end
		else
			return false
		end
	end

	# This method is to apply the discount to the total revenue or to individuals
	def apply(given_data, items_info)
		if @requires[:total]
			if @requires[:percent]
				return given_data * (1 - @discount.to_f / 100)
			else
				return given_data - @discount
			end
		else
			revenue = 0
			@requires[:items].each do |item, qty|
				price = items_info[item][:price]
				if @requires[:percent]
					return price * (1 - @discount.to_f / 100)
				else
					return price - @discount
				end

				revenue += items_info[item][:price] * qty
				given_data[item] = given_data[item] - qty
			end
			return revenue
		end
	end
end