require 'spec_helper'

describe "Tutorials" do
  
  before(:each) do
    @admin = Factory(:user, :admin => true)
    visit signin_path
    fill_in :email,    :with => @admin.email
    fill_in :password, :with => @admin.password
    click_button
  end
  
  describe "creation" do
    
    describe "failure" do
    
      it "should not create a new tutorial" do
        lambda do
          visit new_tutorial_path
          click_button
          response.should render_template('tutorials/new')
          response.should have_tag("div#errorExplanation")
        end.should_not change(Tutorial, :count) 
      end
    end
  
    describe "success" do
    
      it "should create a new tutorial" do
        lambda do
          visit new_tutorial_path
          fill_in "Name",      :with => "new tutorial"
          fill_in "Category",  :with => "category"
          fill_in "Permalink", :with => "permalink"
          fill_in "Content",   :with => "random content"
          fill_in "Page order",  :with => "1"
          click_button
          response.should render_template('tutorials/show')
        end.should change(Tutorial, :count).by(1)
      end
    end
  end
  
  describe "destruction" do
    
    it "should destroy a tutorial" do
      # create one
      visit new_tutorial_path
      fill_in "Name",      :with => "new tutorial"
      fill_in "Category",  :with => "category"
      fill_in "Permalink", :with => "permalink"
      fill_in "Content",   :with => "random content"
      fill_in "Page order",  :with => "1"
      click_button
      # destroy it
      lambda { click_link "delete" }.should change(Tutorial, :count).by(-1)
    end
  end
end
