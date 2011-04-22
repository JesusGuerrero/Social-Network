require 'spec_helper'

describe User do
  before(:each) do
    @attr = {
      :name => "jpoday",
      :email => "joseph.oday@gmail.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end
    
  describe "admin attributes" do
    
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should respond to admin" do
      @user.should respond_to(:admin)
    end
    
    it "should not be an admin by default" do
      @user.should_not be_admin
    end
    
    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end
  
  describe "level attribute" do
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should respond to level" do
      @user.should respond_to(:level)
    end
      
    it "should be 0 by default" do
      @user.level == 0
    end
  end
  
  describe "last_tutorial attribute" do
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should respond to last_tutorial" do
      @user.should respond_to(:last_tutorial)
    end
  
    it "should be 0 by default" do
      @user.last_tutorial == 0
    end
  end
  
  describe "buyer attribute" do
    before(:each) do
      @user = User.create(@attr)
    end
    
    it "should respond to buyer" do
      @user.should respond_to(:buyer)
    end
    
    it "should be false by default" do
      @user.buyer == false
    end
  end
  
  describe "website associations" do
    
    before(:each) do
      @user = User.create(@attr)
      @web1 = Factory(:website, :user => @user, :created_at => 1.day.ago)
      @web2 = Factory(:website, :user => @user, :created_at => 1.hour.ago)
    end
    
    it "should have a websites attribute" do
      @user.should respond_to(:websites)
    end
    
    it "should destroy associated websites" do
      @user.destroy
      [@web1, @web2].each do |website|
        Website.find_by_id(website.id).should be_nil
      end
    end
  end
  
  describe "keyword associations" do
    
    before(:each) do
      @user = User.create(@attr)
      @key1 = Factory(:keyword, :user => @user, :created_at => 1.day.ago)
      @key2 = Factory(:keyword, :user => @user, :created_at => 1.hour.ago)
    end
    
    it "should have a keywords attribute" do
      @user.should respond_to(:keywords)
    end
    
    it "should destroy associated keywords" do
      @user.destroy
      [@key1, @key2].each do |keyword|
        Keyword.find_by_id(keyword.id).should be_nil
      end
    end
  end
  
  describe "project associations" do
    
    before(:each) do
      @user = User.create(@attr)
      @project = Factory(:project, :user => @user)
    end
    
    it "should have a projects attribute" do
      @user.should respond_to(:projects)
    end
    
    it "should destroy associated projects" do
      @user.destroy
      Project.find_by_id(@project.id).should be_nil
    end
  end
end
