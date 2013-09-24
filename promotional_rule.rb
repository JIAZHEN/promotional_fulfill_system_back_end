require_relative 'math_helper'

class PromotionalRule

	def initialize(discount, requires, options = {})
		@discount = discount
		@requires = requires
		@options = options
	end

	def eligible?(given_data)
		return (@requires[:total] && given_data >= @requires[:threshold])
					 or
					 (@requires[:each] && given_data >= @requires[:threshold])
	end

	# This method is to apply the discount to the total revenue or to individuals
	def apply(given_data)
		if given_data.instance_of? Hash and @requires[:each]

		elsif given_data.instance_of? Float and @requires[:total]
			if @options[:percent]
				return given_data * (1 - @discount.to_f / 100)
			else
				return given_data - @discount
			end
		else
			0
		end
	end
end