require 'spec_helper'

describe Tutorial do
  before(:each) do
    @attr = {
      :name => "Website Setup Overview",
      :category => "website",
      :permalink => "overview",
      :content => "here's the content",
      :page_order => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    Tutorial.create!(@attr)
  end
  
  describe "validations" do

    it "should require a nonblank name" do
      Tutorial.new(:name => " ").should_not be_valid
    end

    it "should require a nonblank category" do
      Tutorial.new(:category => " ").should_not be_valid
    end

    it "should require a nonblank permalink" do
      Tutorial.new(:permalink => " ").should_not be_valid
    end

    it "should require a nonblank content" do
      Tutorial.new(:content => " ").should_not be_valid
    end
    
    it "should require a nonblank page_order" do
      Tutorial.new(:page_order => " ").should_not be_valid
    end

    it "should reject categories with spaces" do
      Tutorial.new(@attr.merge(:category => "example category")).should_not be_valid
    end

    it "should reject permalinks with spaces" do
      Tutorial.new(@attr.merge(:permalink => "example permalink")).should_not be_valid
    end
  end
end
