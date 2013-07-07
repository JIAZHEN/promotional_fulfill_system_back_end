require_relative 'item'

class Checkout

	attr_reader 	:items
	attr_accessor 	:promotional_rules

	def initialize(promotional_rules = Hash.new)
		@promotional_rules = promotional_rules
		@items = Hash.new
	end

	def scan(item)
		if @items.has_key?(item.product_code)
			@items[item.product_code].quantity += item.quantity
		else
			@items[item.product_code] = item
		end
	end

	def total
		replace_amts = Array.new
		# check the rules for individuals first
		@promotional_rules.each do |promotional_rule|
			total_revenue = orig_amt(replace_amts)
			if promotional_rule.rule_type != "overall" &&
			   promotional_rule.eligible?(@items, total_revenue)

			   replace_amt = promotional_rule.apply(@items, total_revenue)
			   unless replace_amt.nil?
			   		replace_amts.push(replace_amt)
			   end
			end
		end

		# now we check the rules for overall
		# only the lowest rule can be applied
		total_revenue = orig_amt(replace_amts)
		lowest_amt = total_revenue
		@promotional_rules.each do |promotional_rule|
			if 	promotional_rule.rule_type == "overall" && 
				promotional_rule.eligible?(nil, total_revenue)

				lowest_amt = [ promotional_rule.apply(nil, total_revenue), 
							   lowest_amt ].min
			end
		end
		return lowest_amt
	end

	private
		def orig_amt(replace_amts = nil)
			amount = 0
			items.each do |code, item|
				amount += item.total
			end

			unless replace_amts.nil?
				replace_amts.each do |replace_amt|
					amount += replace_amt
				end
			end
			return amount
		end
end