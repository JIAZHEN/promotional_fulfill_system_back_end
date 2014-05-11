promotional_fulfill_system_back_end
===================================

This is the back end of promotional fulfil system. It will scan items in any order and allow web manager to custom promotional rules

#### pricing scheme examples
- three for a dollar (so what’s the price if I buy 4, or 5?)
- $1.99/pound (so what does 4 ounces cost?)
- buy two, get one free (so does the third item have a price?)
- buy more than two, price drops to 8.50
- meal deal, one sandwich, one snack, one drink the cheapest is free
- meal deal, one sandwich, one snack, one drink only up to 3
- any 3 for 10

#### issues to be considered
- does fractional money exist?
- when (if ever) does rounding take place?
- how do you keep an audit trail of pricing decisions (and do you need to)?
- are costs and prices the same class of thing?
- if a shelf of 100 cans is priced using “buy two, get one free”, how do you value the stock?

#### design
In order to flexible enough to deal with pricing schemes in supermarket, the interface to checkout should be like

    co = Checkout.new(promotional_rules)
    co.scan(item)
    co.scan(item)
    price = co.total

So, checkout system have the ability to scan, store item and quantity in a hash. The scanned item should be just the product-code, the latest price should be from DB (in this case to keep it simple will be a constant hash).

Supermarket manager can add as much promotional rules. Promotional rules will be sorted by descending discounts so customers can have the best offers as they can. As an user, I would hope I can create promotional rule as

    Rule.new(total: ">= 60", discount: "10%") # "10%".to_f < 0
    Rule.new("001" => ">= 2", price: 8.5)
    Rule.new(["001", "002", "003"], free: :min)
    Rule.new("any 3" => ["001", "003", "004", "008", "009"], just: 10)
    Rule.new(["004", "005", "006"], up_to: 3)