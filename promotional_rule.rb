require_relative 'item'
require_relative 'math_helper'

# This is the class to create custom promotional rules
# To define a rule for total discount:
# 		PromotionalRule.new("overall", "10%", 60)
# To define a rule for individual product:
# 		PromotionalRule.new("indiv", 8.5, { :applied_to => "price", :combos => { "001" => 2 } } )

class PromotionalRule

	attr_reader		:rule_type
	attr_accessor 	:criteria, :amount

	# There are only two possible rule types: overall or indiv (individual).
	# Rule Type indicates the rule is to have a total price discount or to have a discount
	# in the single product or combination of products.
	# Amount means the amount of discount, it can be percentage(with % symbol) or numberic
	# Criteria is the criteria to meet the rule
	def initialize(rule_type, amount, criteria)

		unless ["overall", "indiv"].include?rule_type.downcase
			raise ArgumentError, 'RuleType is either overall or individual'
		end

		unless rule_type != "indiv" || (criteria.has_key?(:applied_to) && criteria.has_key?(:combos))
			raise ArgumentError, 'Criteria for individual must have keys applied_to and combos'
		end
		
		@rule_type = rule_type
		@amount = amount
		@criteria = criteria
	end

	# This method is to calculate the total revenue/price after applying the discount amount
	def process_amount(amount, orig_amount = nil)
		if amount.to_s.include? "%"
			# percentage means xx% off
			MathHelper.round(orig_amount * (1 - amount.gsub("%", "").to_f * 1.0 / 100))
		elsif amount.to_f < 0
			# negative amount means XXX off
			MathHelper.round(orig_amount + amount.to_f)
		else
			# positive or zero amount means use this to replace the original
			MathHelper.round(amount.to_f)
		end
	end

	# This method is to determine if the rule has been satisfied
	# Items indicate the products in the basket
	# Total indicates the amount of revenues in the basket
	def eligible?(items, total)
		if @rule_type == "overall"
			if @criteria.class == Range
				@criteria.include?total
			elsif @criteria.class == Fixnum
				total >= @criteria
			end
		else
			# must for individual
			condition_meet = true
			@criteria[:combos].each do |key, value|
				unless (items.has_key?key) && ((items[key].quantity.to_i) >= value.to_i)
					condition_meet = false
				end
			end
			return condition_meet
		end
	end

	# This method is to apply the discount to the total revenue or to individuals
	def apply(items, total)
		if @rule_type == "overall"
			process_amount(@amount, total)
		else
			# must for individual
			# if the rule is to change the price,
			# it will replace the products' price as the discount amount
			if @criteria[:applied_to] == "price"
				@criteria[:combos].each do |key, value|
					items[key].price = process_amount(amount, items[key].price)
				end
				return nil
			elsif @criteria[:applied_to] == "amount"
				# if the rule is to change the price,
				# it will reduce the quantity of products
				# and return the replace amount
				@criteria[:combos].each do |key, value|
					items[key].quantity -= value
				end
				# return the fix amount
				process_amount(@amount)
			else
				raise ArgumentError, 'Only can apply to price or amount'
			end
		end
	end
end