# This is the class to fulfil the back end of checkout system

class Checkout

	attr_reader 	:items

	def initialize(rules = Hash.new)
		@rules = rules
		@items = Hash.new
	end

	def scan(item)
		if @items[item]
			@items[item] += 1
		else
			@items[item] = 1
		end
	end

	def total(items_info)
		revenue = 0
		# check the rules for individuals first
		@rules.each { |rule| revenue += rule.apply @items, items_info if rule.eligible? @items }
		@items.each { |item, qty| revenue += items_info[item][:price] * qty }
		# now we check the rules for overall
		@rules.each { |rule| revenue = rule.apply revenue.to_f, items_info if rule.eligible? revenue.to_f } 
		return revenue
	end
end