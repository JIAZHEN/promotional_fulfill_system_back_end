require 'spec_helper'

describe "Supermarket rule" do
  subject(:instance) { Rule.new(:total) }

  it { is_expected.to respond_to(:total) }
  it { is_expected.to respond_to(:items) }

  describe "#initialize" do
    describe "when rule type is not given" do
      it "cannot create rule and raise error" do
        expect { Rule.new }.to raise_error(ArgumentError)
      end
    end
  end

  describe "rule for total" do
    before(:each) { @conditions = { comparison: :>=, threshold: 60, discount: "10%" } }

    describe "#eligible_for?" do
      describe "when rule type is undefined" do
        before(:each) { @rule = Rule.new(:unknown, @conditions) }

        it "call eligible_for? will raise error" do
          expect { @rule.eligible_for?(50) }.to raise_error(ArgumentError)
        end
      end

      describe "condition is total over/equal 60" do
        before(:each) { @rule = Rule.new(:total, @conditions) }
        subject { @rule }

        it { should_not be_eligible_for(50) }
        it { should be_eligible_for(60) }
      end
    end

    describe "#apply" do
      describe "when discount is 10% off" do
        before(:each) { @rule = Rule.new(:total, @conditions) }

        it "should return 54 when balance is 60" do
          @rule.apply_to(60).should == 54
        end
      end

      describe "when discount is 5 pounds off" do
        before(:each) do
          @conditions[:discount] = "5"
          @rule = Rule.new(:total, @conditions)
        end

        it "should return 55 when balance is 60" do
          @rule.apply_to(60).should == 55
        end
      end
    end
  end

  describe "rule for price drop" do
    before(:each) { @conditions = { item: "001", qty: 2, drop_to: 8.5 } }

    describe "#eligible_for?" do
      before(:each) { @rule = Rule.new(:price_drop, @conditions) }
      subject { @rule }

      it { should_not be_eligible_for({ "001" => { qty: 1, price: 9 } }) }
      it { should be_eligible_for({ "001" => { qty: 2, price: 8.5 } }) }
    end

    describe "#apply?" do
      before(:each) { @rule = Rule.new(:price_drop, @conditions) }
      subject { @rule }

      describe "when buy three 001" do
        it "should change the price from 9 to 8.5" do
          items = { "001" => { qty: 1, price: 9 } }
          @rule.apply_to(items)
          items["001"][:price].should == 8.5
        end
      end
    end
  end
end