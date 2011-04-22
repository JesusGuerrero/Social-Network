require 'spec_helper'

describe Keyword do
  before(:each) do
    @user = Factory(:user)
    @attr = {
      :keyphrase => "example phrase",
      :description => "keyword description",
      :user_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    @user.keywords.create!(@attr)
  end
  
  describe "user associations" do
    
    before(:each) do
      @keyword = @user.keywords.create(@attr)
    end
    
    it "should have a user attribute" do
      @keyword.should respond_to(:user)
    end
    
    it "should have the right associate user" do
      @keyword.user_id.should == @user.id
      @keyword.user.should == @user
    end
  end
  
  describe "validations" do
    
    it "should require a user id" do
      Keyword.new(@attr).should_not be_valid
    end
    
    it "should require a nonblank keyphrase" do
      @user.keywords.build(:keyphrase => " ").should_not be_valid
    end
    
    it "should require a nonblank description" do
      @user.keywords.build(:description => " ").should_not be_valid
    end
    
    it "should reject long descriptions" do
      @user.keywords.build(:description => "a" * 512).should_not be_valid
    end
  end
  
  describe "content associations" do
      
    before(:each) do
      @user = Factory(:user)
      @attr = {
        :keyphrase => "example phrase",
        :description => "keyword description",
        :user_id => 1
      }
      @keyword = @user.keywords.create(@attr.merge(:user => @user))
      @content = Factory(:content, :keyword => @keyword)
    end
  
    it "should have a contents attribute" do
      @keyword.should respond_to(:content)
    end
  
    it "should have the right contents" do
      @keyword.content.should == @content
    end
  
    it "should destroy associated contents" do
      @keyword.destroy
      Content.find_by_id(@content.id).should be_nil
    end
  end
  
  describe "project associations" do
    
    before(:each) do
      @user = Factory(:user)
      @attr = {
        :keyphrase => "example phrase",
        :description => "keyword description",
        :user_id => 1
      }
      @keyword = @user.keywords.create(@attr.merge(:user => @user))
    end
    
    it "should have a project attribute" do
      @keyword.should respond_to(:project)
    end
  end
end
