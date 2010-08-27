require 'currency'

TAX_CODES = {"TX" => 7, "UT" => 6.85, "IL" => 10.0, "NV" => 8.0}
DISCOUNTS = {
  (0...1000) => 0, 
  (1000...5000) => 3, 
  (5000...7000) => 5, 
  (7000...10000) => 7, 
  (10000...Float::INFINITY) => 10
}

class PriceCalculator
  attr_reader :quantity, :price, :tax, :state

  def initialize(args)
    @price = args[0].to_f
    @quantity = args[1].to_i
    @state = args[2]
    @tax = TAX_CODES[@state] || 0
  end
  
  def pre_discount_total
    quantity * price
  end
  
  def pre_tax_total
    pre_discount_total - discount
  end
  
  def total_tax
    pre_tax_total * tax/100
  end
  
  def total
    pre_tax_total + total_tax
  end
  
  def discount_pct 
    DISCOUNTS.to_a.find { |d,v| d.member?(pre_discount_total) }.last
  end
  
  def discount
    pre_discount_total * discount_pct / 100
  end
  
  def print
    <<-EOF.gsub(/^\s*/,'')
      Price:     $#{format_money(price)}
      Quantity:  #{quantity}
      Subtotal:  $#{format_money(pre_discount_total)}
      Discount: -$#{format_money(discount)}
      Tax:       #{tax}% #{state}
      Total:     $#{format_money(total)}
    EOF
  end
  def format_money(amt)
    Currency::Money(amt, :usd).format    
  end
end