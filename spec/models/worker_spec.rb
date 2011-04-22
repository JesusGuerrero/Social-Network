require 'spec_helper'

describe Worker do
  before(:each) do
    @attr = {
      :name => "Billy Writer",
      :basecamp_id => "1",
      :category => "writer"
    }
  end

  it "should create a new instance given valid attributes" do
    Worker.create!(@attr)
  end
  
  it "should require a name" do
    no_name_worker = Worker.new(@attr.merge(:name => ""))
    no_name_worker.should_not be_valid
  end
  
  it "should require a basecamp id" do
    no_id_worker = Worker.new(@attr.merge(:basecamp_id => ""))
    no_id_worker.should_not be_valid
  end
  
  it "should require a category" do
    no_category_worker = Worker.new(@attr.merge(:category => ""))
    no_category_worker.should_not be_valid
  end
  
  it "should reject duplicate names" do
    # Put a user with given email address into the database.
    Worker.create!(@attr)
    user_with_duplicate_name = Worker.new(@attr)
    user_with_duplicate_name.should_not be_valid
  end
  
  it "should reject duplicate basecamp ids" do
    # Put a user with given email address into the database.
    Worker.create!(@attr)
    user_with_duplicate_id = Worker.new(@attr)
    user_with_duplicate_id.should_not be_valid
  end
end
