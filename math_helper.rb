require 'bigdecimal'

class MathHelper
	
	def round(value, precision = 2)
		bd = BigDecimal(value.to_s)
		bd.round(precision, BigDecimal::ROUND_HALF_UP).to_f
	end
end

