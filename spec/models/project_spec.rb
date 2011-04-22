require 'spec_helper'

describe Project do
  before(:each) do
    @user = Factory(:user)
    @attr = {
      :name => "test",
      :active => "false",
      :user_id => 1,
      :basecamp_id => 1,
      :description => "test project description",
      :notes => "PR 0"
    }
  end

  it "should create a new instance given valid attributes" do
    @user.projects.create!(@attr)
  end
  
  it "should require a name" do
    no_name_project = Project.new(@attr.merge(:name => ""))
    no_name_project.should_not be_valid
  end
  
  it "should require a description" do
    no_desc_project = Project.new(@attr.merge(:description => ""))
    no_desc_project.should_not be_valid
  end
  
  describe "user associations" do
    before(:each) do
      @project = @user.projects.create(@attr)
    end
    
    it "should respond to user" do
      @project.should respond_to(:user)
    end
    
    it "should have the right associated user" do
      @project.user_id.should == @user.id
      @project.user.should == @user
    end
  end
  
  describe "keyword associations" do
    before(:each) do
      @project = @user.projects.create(@attr)
    end
    
    it "should respond to keywords" do
      @project.should respond_to(:keywords)
    end
  end
end
