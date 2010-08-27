require 'spec_helper'

describe PriceCalculator do
  describe "Tax" do
    before do 
      ruby_args = ["23.45", "10", "TX"]
      @pc = PriceCalculator.new ruby_args
    end
  
    it "accepts a price" do
      @pc.price.should == 23.45
    end
  
    it "prints a price" do
      @pc.print.should match(/23.45/)
    end

    it "accepts a qty" do
      @pc.quantity.should == 10
    end
  
    it "calulates a pre_tax total" do
      @pc.pre_tax_total.should == 234.5
    end
  
    it "calculates a total with tax" do
      @pc.tax.should == 7.0
    end
  
    it "calculates tax" do 
      @pc.total_tax.should be_close(234.5 * 0.07, 0.001)
    end
  
    it "calculates total" do 
      @pc.total.should be_close(234.5 * 1.07, 0.001)
    end
  end
  
  describe "Discounts" do
    before do 
      ruby_args = ["1000", "1", "TX"]
      @pc = PriceCalculator.new ruby_args
    end

    it "calulates 3% a discount if >=1000 <5000" do
      @pc.discount.should == 30
    end
    
    it "includes the discount in the pre tax total" do 
      @pc.pre_tax_total.should be_close(970, 0.01)
    end
  end

end