require_relative 'item'

class PromotionalRule

	attr_accessor :rule_type, :amount, :criteria

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
				if !items.has_key?key || (items[key].quantity.to_i) < value.to_i
					condition_meet = false
				end
			end
			return condition_meet
		end
	end

	def applied(items, total)
		if @rule_type == "overall"
			process_amount(@amount, total)
		else
			# must for individual
			if @criteria[:applied_to] == "price"
				@criteria[:combos].each do |key, value|
					items[key].price = process_amount(amount, items[key].price)
				end
			else
				# must be amount
				@criteria[:combos].each do |key, value|
					items[key].quantity -= value
				end
				# return the fix amount
				process_amount(@amount)
			end
		end
	end

	def process_amount(amount, orig_amount = nil)
		if amount.to_s.include? "%"
			# percentage means xx% off
			orig_amount * (1 - amount.gsub("%", "").to_f * 1.0 / 100)
		elsif amount.to_f < 0
			# negative amount means XXX off
			orig_amount + amount.to_f
		else
			# positive or zero amount means use this to replace the original
			amount.to_f
		end
	end
end