require 'spec_helper'

describe "Supermarket rule" do
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
      describe "when call the method without given data" do
        before(:each) { @rule = Rule.new(:total, @conditions) }

        it "call eligible_for? will raise error" do
          expect { @rule.eligible_for? }.to raise_error(ArgumentError)
        end
      end

      describe "when conditions have no comparison" do
        before(:each) do
          @conditions.delete(:comparison)
          @rule = Rule.new(:total, @conditions)
        end

        it "call eligible_for? will raise error" do
          expect { @rule.eligible_for?(70) }.to raise_error(TypeError)
        end
      end

      describe "when conditions have no threshold" do
        before(:each) do
          @conditions.delete(:threshold)
          @rule = Rule.new(:total, @conditions)
        end

        it "call eligible_for? will raise error" do
          expect { @rule.eligible_for?(70) }.to raise_error(ArgumentError)
        end
      end

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
end