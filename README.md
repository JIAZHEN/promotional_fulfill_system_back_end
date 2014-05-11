promotional_fulfill_system_back_end
===================================

This is the back end of promotional fulfil system. It will scan items in any order and allow web manager to custom promotional rules

#### pricing scheme examples
- three for a dollar (so what’s the price if I buy 4, or 5?)
- $1.99/pound (so what does 4 ounces cost?)
- buy two, get one free (so does the third item have a price?)

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

Supermarket manager can add as much promotional rules. Promotional rules will be sorted by descending discounts so customers can have the best offers as they can.