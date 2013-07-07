require 'spec_helper'

describe MathHelper do

	before { @rounding_error = 129.95 * 100 }

	describe "rounding error" do
		it "has too many unexpected decimals" do
			@rounding_error.should == 12994.999999999998
		end
	end

	describe "#round" do

		it "should solve the rounding error" do
			MathHelper.round(@rounding_error).should == 12995
		end

		it "should round it in two decimal by default" do
			MathHelper.round(75.556).should == 75.56
		end

		it "should round with specific number of decimals" do
			MathHelper.round(75.1234567, 3).should == 75.123
		end
	end

end