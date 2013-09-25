require 'spec_helper'

describe "Checkout system" do

	let(:item_info) do
		{ "001" => { price: 9.25, name: "Lavender heart" },
			"002" => { price: 45.00, name: "Personalised cufflinks" },
			"003" => { price: 19.95, name: "Kids T-shirt" } }
	end

	describe "scan" do
		before(:each) { @co = Checkout.new }

		describe "single item" do
			before(:each) { @co.scan("001") }

			it "should increase the quantity of the correct items" do
				@co.items["001"].should == 1
			end
		end

		describe "multiple items" do
			before(:each) do
				@co.scan("001")
				@co.scan("002")
				@co.scan("001")
			end

			it "should increase the quantity of the correct items" do
				@co.items["001"].should == 2
				@co.items["002"].should == 1
			end
		end
	end

	describe "checkout" do

		let(:rule_over_60) { PromotionalRule.new(10, total: true, percent: true, amount: 60) }

		describe "without promotional rule" do
			before(:each) do
				@co = Checkout.new
				@co.scan("001")
				@co.scan("002")
				@co.scan("001")
			end
			
			it "should return the correct total" do

			end
		end

		describe "when spend over 60" do
			it "should get 10% off" do
			end
		end

		describe "when buy 2 or more lavender hearts" do
			it "should drop the price to 8.5 then return the correct total" do
			end
		end

		describe "when buy 2 lavender hearts, 1 Personalised cufflinks and 1 Kids T-shirt" do
			it "lavender hearts price should drop to 8.5 and get 10% off" do
			end
		end
	end
end
	
