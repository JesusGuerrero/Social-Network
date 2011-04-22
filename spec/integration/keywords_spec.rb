require 'spec_helper'

describe "Keywords" do
  
  before(:each) do
    @user = Factory(:user, :level => 2)
    visit signin_path
    fill_in :email,    :with => @user.email
    fill_in :password, :with => @user.password
    click_button
  end
  
  describe "creation" do
    
    describe "failure" do
    
      it "should not create a new keyword" do
        lambda do
          visit new_keyword_path
          click_button
          response.should render_template('keywords/new')
          response.should have_tag("div#errorExplanation")
        end.should_not change(Keyword, :count) 
      end
    end
  
    describe "success" do
    
      it "should create a new keyword" do
        lambda do
          visit new_keyword_path
          fill_in "Keyphrase",   :with => "new keyword"
          fill_in "Description", :with => "keyword description"
          # fill_in "URL",         :with => "http://example.com"
          click_button
          response.should render_template('users/show')
        end.should change(Keyword, :count).by(1)
      end
    end
  end
  
  describe "destruction" do
    
    it "should destroy a keyword" do
      # create one
      visit new_keyword_path
      fill_in "Keyphrase",   :with => "new keyword"
      fill_in "Description", :with => "keyword description"
      # fill_in "URL",         :with => "http://example.com"
      click_button
      # destroy it
      lambda { click_link "delete" }.should change(Keyword, :count).by(-1)
    end
  end
end
