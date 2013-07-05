require 'spec_helper'

describe MathHelper do

	before { @rounding_error = 129.95 * 100 }

	describe "rounding error" do
		it "should not equal as we expected" do
			@rounding_error.should_not == 12995
		end
	end

	describe "#round" do
		before { @math_helper = MathHelper.new }

		it "should solve the rounding error" do
			@math_helper.round(@rounding_error).should == 12995
		end

		it "should round it in two decimal by default" do
			@math_helper.round(75.556).should == 75.56
		end
	end

end