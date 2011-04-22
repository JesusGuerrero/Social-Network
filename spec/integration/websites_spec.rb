require 'spec_helper'

describe "Websites" do
  
  before(:each) do
    @user = Factory(:user, :level => 1)
    visit signin_path
    fill_in :email,    :with => @user.email
    fill_in :password, :with => @user.password
    click_button
  end
  
  describe "creation" do
    
    describe "failure" do
    
      it "should not create a new website" do
        lambda do
          visit new_website_path
          click_button
          response.should render_template('websites/new')
          response.should have_tag("div#errorExplanation")
        end.should_not change(Website, :count) 
      end
    end
  
    describe "success" do
    
      it "should create a new website" do
        lambda do
          visit new_website_path
          fill_in "Domain",   :with => "http://www.example.com"
          fill_in "Description", :with => "website description"
          click_button
          response.should render_template('users/show')
        end.should change(Website, :count).by(1)
      end
    end
  end
  
  describe "destruction" do
    
    it "should destroy a website" do
      # create one
      visit new_website_path
      fill_in "Domain",   :with => "http://www.example.com"
      fill_in "Description", :with => "website description"
      click_button
      # destroy it
      lambda { click_link "delete" }.should change(Website, :count).by(-1)
    end
  end
end
