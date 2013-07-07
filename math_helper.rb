require 'bigdecimal'

class MathHelper
	
	# This is a class to solve the rounding errors
	# Value is the number we would like to round
	# Precision is to determine how many digits after decimal point,
	# 2 is the default value
	def self.round(value, precision = 2)
		bd = BigDecimal(value.to_s)
		bd.round(precision, BigDecimal::ROUND_HALF_UP).to_f
	end
end

