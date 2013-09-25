require_relative 'math_helper'

class PromotionalRule

	def initialize(items_info, discount, requires = {})
		@discount = discount
		@requires = requires
		@items_info = items_info
	end

	def eligible?(given_data)
		if @requires[:total]
			return given_data >= @requires[:amount]
		elsif @requires[:each]
			@requires[:items].each do |item, qty|
				return false if given_data[item] < qty
			end
		else
			return false
		end
	end

	# This method is to apply the discount to the total revenue or to individuals
	def apply(given_data)
		if @requires[:total]
			if @requires[:percent]
				return given_data * (1 - @discount.to_f / 100)
			else
				return given_data - @discount
			end
		else
			revenue = 0
			@requires[:items].each do |item, qty|
				price = @items_info[item][:price]

				if @requires[:percent]
					return price * (1 - @discount.to_f / 100)
				else
					return price - @discount
				end

				revenue += @items_info[item][:price] * qty
				given_data[item] = given_data[item] - qty
			end
			return revenue
		end
	end
end