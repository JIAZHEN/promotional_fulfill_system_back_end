require 'spec_helper'

describe Item do

	describe "#new" do

		describe "with valid parameters" do

			before do
				@item = Item.new "00A", 10.11, 10
			end

			subject { @item }

			it { should be_an_instance_of Item }
			
			it { should respond_to(:product_code) }
			it { should respond_to(:price) }
			it { should respond_to(:quantity) }

			it { should respond_to(:total) }

			it "returns the correct total revenue" do
				@item.total.should equal(101.1)
			end

			it "should convert the product code to downcase" do
				@item.product_code.should eq("00a")
			end

		end

		describe "with invalid parameters" do

			it "should raise error as no argument" do
				expect { Item.new }.to raise_error
			end

			it "should raise error as product code is nil" do
				expect { Item.new nil, 10.11, 1 }.to raise_error
			end
			it "should raise error as product code is not string" do
				expect { Item.new 1, 10.11, 1 }.to raise_error
			end

			it "should raise error as price is nil" do
				expect { Item.new "001", nil, 1 }.to raise_error
			end
			it "should raise error as price is not Numeric" do
				expect { Item.new "001", "10.11", 1 }.to raise_error
			end

			it "should raise error as quantity is nil" do
				expect { Item.new "001", 10.11, nil }.to raise_error
			end
			it "should raise error as quantity is not Numeric" do
				expect { Item.new "001", 10.11, "1" }.to raise_error
			end

		end
	end
end