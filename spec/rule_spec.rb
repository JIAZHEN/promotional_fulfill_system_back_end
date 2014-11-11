require 'spec_helper'

describe "Supermarket rule" do
  subject(:instance) { Rule.new }

  it { is_expected.to respond_to(:total) }
  it { is_expected.to respond_to(:items) }
  it { is_expected.to respond_to(:balance) }
  it { is_expected.to respond_to(:balance?) }
  it { is_expected.to respond_to(:items?) }

  describe "rule for total" do
    let(:rate)        { 0.9 }
    let(:balance)     { { :">" => 60 } }
    let(:total_rule)  { Rule.new(balance: balance)  { |cart| cart.balance * rate } }

    it "returns nil as items" do
      expect(total_rule.items).to be_nil
    end

    it "returns correct balance" do
      expect(total_rule.balance).to eq(balance)
    end

    context "when cart balance is less" do
      let(:cart) { double("cart", balance: 50) }
      it "doesn't match" do
        expect(total_rule).not_to be_match(cart)
      end
    end

    context "when cart balance is more than 60" do
      let(:cart_balance) { 70 }
      let(:cart) { double("cart", balance: cart_balance) }
      it "matches and total is 10% 0ff" do
        expect(total_rule).to be_match(cart)
        expect(total_rule.total(cart)).to eq(cart_balance * rate)
      end
    end
  end

  describe "rule for items" do
    let(:unit_price)  { -1.5 }
    let(:items)       { { "001" => 2 } }
    let(:items_rule)  { Rule.new(items:  items) { |cart| cart["001"] * unit_price } }

    it "returns correct as items" do
      expect(items_rule.items).to eq items
    end

    it "returns nil balance" do
      expect(items_rule.balance).to be_nil
    end

    context "when cart's quantity is less than rule" do
      let(:cart)  { double("cart") }
      before  { allow(cart).to receive(:[]).with("001").and_return(1) }

      it "doesn't match" do
        expect(items_rule).not_to be_match(cart)
      end
    end

    context "when cart's quantity is more than rule" do
      let(:qty)   { 3 }
      let(:cart)  { double("cart") }
      before  { allow(cart).to receive(:[]).with("001").and_return(qty) }

      it "matches and total is using unit_price" do
        expect(items_rule).to be_match(cart)
        expect(items_rule.total(cart)).to eq(qty * unit_price)
      end
    end
  end
end
