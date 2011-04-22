require 'spec_helper'

describe Content do
  before(:each) do
    @keyword = Factory(:keyword)
    @attr = { 
      :link_url => "http://www.example.com",
      :keyword_id => "1" 
    }
  end

  it "should create a new instance given valid attributes" do
    @keyword.create_content(@attr)
  end
  
  describe "keyword associations" do
    
    before(:each) do
      @content = @keyword.create_content(@attr)
    end
    
    it "should have a keyword attribute" do
      @content.should respond_to(:keyword)
    end
    
    it "should have the right associated keyword" do
      @content.keyword_id.should == @keyword.id
      @content.keyword.should == @keyword
    end
  end
  
  describe "validations" do
    
    it "should require a keyword id" do
      Content.new(@attr).should_not be_valid
    end
    
    it "should require a nonblank url" do
      @keyword.build_content(:link_url => " ").should_not be_valid
    end
  end
end
