require 'spec_helper'

describe Website do
  before(:each) do
    @user = Factory(:user)
    @attr = {
      :domain => "http://www.example.com",
      :description => "example site"
    }
  end

  it "should create a new instance given valid attributes" do
    @user.websites.create!(@attr)
  end
  
  describe "user associations" do
    
    before(:each) do
      @website = @user.websites.create!(@attr)
    end
    
    it "should have a user attribute" do
      @website.should respond_to(:user)
    end
    
    it "should have the right associated user" do
      @website.user_id.should == @user.id
      @website.user.should == @user
    end
  end
  
  describe "validations" do
    
    it "should require a user id" do
      Website.new(@attr).should_not be_valid
    end
    
    it "should require a nonblank domain" do
      @user.websites.build(:domain => " ").should_not be_valid
    end
    
    it "should require a nonblank description" do
      @user.websites.build(:description => " ").should_not be_valid
    end
    
    it "should reject a long description" do
      @user.websites.build(:description => "a" * 512).should_not be_valid
    end
  end
end
