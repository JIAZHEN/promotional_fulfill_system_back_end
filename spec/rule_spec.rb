require 'spec_helper'

describe "Supermarket rule" do
  describe "#initialize" do
    describe "when rule type is empty" do
      it "cannot create rule and raise error" do
        expect { Rule.new }.to raise_error(ArgumentError)
      end
    end
  end

  describe "rule for total" do
    describe "#eligible_for?" do
      before(:each) { @conditions = { comparison: :>=, threshold: 60, discount: "10%" } }

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

      describe "condition is total over/equal 60" do
        before(:each) { @rule = Rule.new(:total, @conditions) }
        subject { @rule }

        it { should_not be_eligible_for(50) }
        it { should be_eligible_for(60) }
      end
    end
  end
end