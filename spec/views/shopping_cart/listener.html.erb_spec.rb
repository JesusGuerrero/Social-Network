require 'spec_helper'

describe "/shopping_cart/listener" do
  before(:each) do
    render 'shopping_cart/listener'
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.should have_tag('p', %r[Find me in app/views/shopping_cart/listener])
  end
end
