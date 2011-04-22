require 'spec_helper'

describe UsedKeyword do
  before(:each) do
    @attr = {
      :keyword_id => 1,
      :project_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    UsedKeyword.create!(@attr)
  end
  
  describe "associations" do
    
    before(:each) do
      @used_keyword = UsedKeyword.create(@attr)
    end

    it "should have a project attribute" do
      @used_keyword.should respond_to(:project)
    end
    
    it "should have a keyword attribute" do
      @used_keyword.should respond_to(:keyword)
    end
  end
end
