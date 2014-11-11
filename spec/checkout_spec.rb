require 'spec_helper'

describe "Checkout system" do
  let(:checkout) { Checkout.new }

  describe "#scan" do
    describe "single item" do
      before { checkout.scan("001") }

      it "should increase the quantity of the correct items and include item price" do
        expect(checkout.cart.items).to eq({ "001" => 1 })
      end
    end

    describe "multiple items" do
      before do
        checkout.scan("001")
        checkout.scan("002")
        checkout.scan("001")
      end

      it "should increase the quantity of the correct items" do
        expect(checkout.cart.items).to eq({ "001" => 2, "002" => 1 })
      end
    end
  end

  describe "#checkout" do
    describe "without promotional rule" do
      before(:each) do
        checkout.scan("001")
        checkout.scan("002")
        checkout.scan("001")
      end

      it "should return the correct total" do
        expect(checkout.total).to eq 63.5
      end
    end

    describe "with promotional rules" do
      let(:over_60)     { Rule.new(balance: { :">" => 60 })  { |cart| cart.balance * 0.9 } }
      let(:price_drop)  { Rule.new(items: { "001" => 2 }) { |cart| cart["001"] * (8.5 - 9.25) } }

      describe "when spend over 60" do
        let(:checkout)    { Checkout.new(over_60) }
        before(:each) do
          checkout.scan("001")
          checkout.scan("002")
          checkout.scan("003")
        end

        it "should get 10% off" do
          expect(checkout.total).to eq 66.78
        end
      end

      describe "when buy 2 or more lavender hearts" do
        let(:checkout)    { Checkout.new(price_drop) }
        before(:each) do
          checkout.scan("001")
          checkout.scan("003")
          checkout.scan("001")
        end

        it "should drop the price to 8.5 then return the correct total" do
          expect(checkout.total).to eq 36.95
        end
      end

      describe "when buy 2 lavender hearts, 1 Personalised cufflinks and 1 Kids T-shirt" do
        let(:checkout)    { Checkout.new(price_drop, over_60) }
        before(:each) do
          checkout.scan("001")
          checkout.scan("002")
          checkout.scan("001")
          checkout.scan("003")
        end

        it "lavender hearts price should drop to 8.5 and get 10% off" do
          expect(checkout.total).to eq 73.76
        end
      end
    end
  end
end

