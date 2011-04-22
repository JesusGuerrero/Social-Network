require 'spec_helper'

describe ShoppingCartController do

  #Delete these examples and add some real ones
  it "should use ShoppingCartController" do
    controller.should be_an_instance_of(ShoppingCartController)
  end


  describe "GET 'listener'" do
    it "should be successful" do
      get 'listener'
      response.should be_success
    end
  end
end
