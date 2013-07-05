require 'spec_helper'

describe PromotionalRule do

	
	describe "#new" do

		describe "with invalid parameters" do

			before do
				@criteria = { :applied_to => "price", :combos => { "001" => 2 } }
			end

			it "should raise error as no argument" do
				expect { PromotionalRule.new }.to raise_error
			end
			it "should raise error as rule type is nil" do
				expect { PromotionalRule.new(nil, 10.11, @criteria) }.to raise_error
			end
			it "should raise error as rule type is not string" do
				expect { PromotionalRule.new(1, 10.11, @criteria) }.to raise_error
			end
			it "should raise error as rule type is not valid" do
				expect { PromotionalRule.new("1", 10.11, @criteria) }.to raise_error
			end

			it "should raise error as criteria has no required keys" do
				expect { PromotionalRule.new("indiv", 10.11, @criteria.clear) }.to raise_error
			end

		end

		describe "with valid parameters" do
			before do
				criteria = { :applied_to => "price", :combos => { "001" => 2 } }
				@promotional_rule = PromotionalRule.new("indiv", 8.5, criteria)
			end

			subject { @promotional_rule }

			it { should be_an_instance_of PromotionalRule }
			it { should respond_to(:eligible?) }
			it { should respond_to(:apply) }
			it { should respond_to(:process_amount) }
		end

		describe "#process_amount" do
			before do
				criteria = { :applied_to => "price", :combos => { "001" => 2 } }
				@promotional_rule = PromotionalRule.new("indiv", 8.5, criteria)
			end

			describe "when the combination of parameters are invalid" do
				it "should raise error as amount is percentage and original amount is not given" do
					expect { @promotional_rule.process_amount("20%") }.to raise_error
				end

				it "should raise error as amount is negative and original amount is not given" do
					expect { @promotional_rule.process_amount("-20") }.to raise_error
				end
			end

			describe "when amount is positive and original amount is not specified" do
				it "should return the amount as numeric" do
					@promotional_rule.process_amount(8.5).should equal(8.5)
				end
			end

			describe "when amount is percentage and original amount is given" do
				it "should return the correct amount with discount" do
					@promotional_rule.process_amount("20%", 100).should equal(80.0)
				end
			end

			describe "when amount is negative and original amount is given" do
				it "should return the correct amount with direct discount" do
					@promotional_rule.process_amount(-20, 100).should equal(80.0)
				end
			end
		end

		describe "#eligible?" do
			describe "with rules for overall" do
				before do
					criteria = 60
					@promotional_rule = PromotionalRule.new("overall", "10%", criteria)
				end

				it "should be true when criteria is fixnum and is euqals to total" do
					@promotional_rule.eligible?(nil, 60).should be_true
				end

				describe "when criteria is Range and is included total" do
					before { @promotional_rule.criteria = 40..60 }
					it "should be true" do
						@promotional_rule.eligible?(nil, 60).should be_true
					end
				end

				describe "when criteria is Range and is not included total" do
					before { @promotional_rule.criteria = 40...60 }
					it "should be true" do
						@promotional_rule.eligible?(nil, 60).should be_false
					end
				end
			end

			describe "with rules for individual" do
				before(:each) do
					criteria = { :applied_to => "", :combos => { "001" => 2 } }
					@promotional_rule = PromotionalRule.new("indiv", 8.5, criteria)
					@items = Hash.new
					@items["001"] = Item.new("001", 9.25, 2)
				end

				it "should be true when items fulfill the combo" do
					@promotional_rule.eligible?(@items, nil).should be_true
				end

				describe "when items don't fulfill the combo" do
					it "should be false" do
						@promotional_rule.eligible?(@items.clear, nil).should be_false
					end
				end
				
				describe "when items fulfill the all combos" do
					before do
						@promotional_rule.criteria = { :applied_to => "amount", 
													   :combos => { "001" => 2, "003" =>1 } 
													 }
						@items["003"] = Item.new("003", 5.5, 3)
					end
					it "should be true" do
						@promotional_rule.eligible?(@items, nil).should be_true
					end
				end
			end
		end

		describe "#applied" do
			describe "with rules for overall" do
				before(:each) do
					criteria = 60
					@promotional_rule = PromotionalRule.new("overall", "10%", criteria)
				end

				describe "when rule is eligible" do
					before { @total = 60 }

					describe "and rule amount is percentage" do
						it "should calculate the final amount correctly" do
							@promotional_rule.apply(nil, @total).should equal(54.0)
						end
					end

					describe "and rule amount is negative numeric" do
						before { @promotional_rule.amount = -1.1 }
						it "should calculate the final amount correctly" do
							@promotional_rule.apply(nil, @total).should equal(58.9)
						end
					end

					describe "and rule amount is positive numeric" do
						before { @promotional_rule.amount = 50 }
						it "should replace the final amount by the rule amount" do
							@promotional_rule.apply(nil, @total).should equal(50.0)
						end
					end
				end
			end

			describe "with rules for individual" do
				describe "when the rule is eligible" do
					describe "and rule is applied_to price" do
						before do
							criteria = { :applied_to => "price", :combos => { "001" => 2 } }
							@promotional_rule = PromotionalRule.new("indiv", 8.5, criteria)
							@items = Hash.new
							@items["001"] = Item.new("001", 9.25, 2)
						end
						describe "and the rule amount is positive numeric" do
							before do 
								@promotional_rule.apply(@items, nil)
								@expect_items = Hash.new
								@expect_items["001"] = Item.new("001", 8.5, 2)
							end
							it "should replace item price" do
								@expect_items.should == @items
							end
						end

						describe "and the rule amount is negative numeric" do
							before do 
								@promotional_rule.amount = -2
								@promotional_rule.apply(@items, nil)
								@expect_items = Hash.new
								@expect_items["001"] = Item.new("001", 7.25, 2)
							end
							it "item price should minus the rule amount and get updated" do
								@expect_items.should == @items
							end
						end

						describe "and the rule amount is percentage" do
							before do 
								@promotional_rule.amount = "10%"
								@promotional_rule.apply(@items, nil)
								@expect_items = Hash.new
								# there is a round error here
								@expect_items["001"] = Item.new("001", 8.33, 2)
							end
							it "item price should minus the rule amount and get updated" do
								@expect_items.should == @items
							end
						end
					end

					describe "and rule is applied_to amount" do
						before do
							criteria = { :applied_to => "amount", 
										 :combos => { "001" => 1, "002" => 1 } }
							@promotional_rule = PromotionalRule.new("indiv", 16, criteria)
							@items = Hash.new
							@items["001"] = Item.new("001", 9.25, 2)
							@items["002"] = Item.new("002", 7.25, 1)

							@expect_items = Hash.new
							@expect_items["001"] = Item.new("001", 9.25, 1)
							@expect_items["002"] = Item.new("002", 7.25, 0)
						end

						describe "after applied" do
							before { @result = @promotional_rule.apply(@items, nil) }
							it "should reduce the items quantity and return the rule amount" do
								@expect_items.should == @items
								@result.should == 16
							end
						end
					end
					
				end
			end
		end
	end


end