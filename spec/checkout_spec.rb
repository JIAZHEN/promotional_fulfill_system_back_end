require 'spec_helper'

describe Checkout do

	before(:each) do
		@co = Checkout.new
	end

	subject { @co }

	describe "#new" do

		it { should be_an_instance_of Checkout }
		it { should respond_to(:scan) }
		it { should respond_to(:items) }
		it { should respond_to(:total) }
		it { should_not respond_to(:orig_amt) }
	end

	describe "#scan" do
		before do
			@co.scan(Item.new("001", 9.25, 1))
			@co.scan(Item.new("002", 20.5, 3))
			@co.scan(Item.new("001", 9.25, 1))
		end

		describe "scan items in any order" do
			before do
				@expect_items = Hash.new
				@expect_items["001"] = Item.new("001", 9.25, 2)
				@expect_items["002"] = Item.new("002", 20.5, 3)
			end
			it "should store scanned items" do
				@expect_items.should == @co.items
			end
		end
	end

	describe "#total" do

		# describe "when no promotional rule" do
		# 	before do
		# 		@co.scan(Item.new("001", 9.25, 2))
		# 		@co.scan(Item.new("002", 45.00, 1))
		# 		@co.scan(Item.new("003", 19.95, 1))
		# 	end
		# 	it "should return the correct total directly" do
		# 		@co.total.should == 83.45
		# 	end
		# end

		describe "when there are rules" do
			before do
				@co.promotional_rules = promotional_rules = [
					PromotionalRule.new("overall", "10%", 60),
					PromotionalRule.new("indiv", 8.5, { :applied_to => "price", :combos => { "001" => 2 } } )
				]
			end
			describe "only total meet the rule" do
				before do
					@co.scan(Item.new("001", 9.25, 1))
					@co.scan(Item.new("002", 45.00, 1))
					@co.scan(Item.new("003", 19.95, 1))
				end
				it "should apply the discount and calculate the correct total" do
					@co.total.should == 66.78
				end
			end
		end

	end

end