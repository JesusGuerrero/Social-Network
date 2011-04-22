require 'spec_helper'

describe BasecampController do
  
  describe "access control" do
    
    describe "for a non signed-in user" do
    
      it "should deny access to 'project1'" do
        get :project1
        response.should redirect_to signin_path
      end
      
      it "should deny access to 'project2'" do
        get :project2
        response.should redirect_to signin_path
      end
    end
    
    describe "for a signed-in user" do
      before(:each) do
        activate_authlogic
        @user = Factory(:user)
        test_sign_in(@user)
        @project = Factory(:project, :user => @user)
      end
      
      it "should deny access to project 1" do
        get :project1, :id => @project
        response.should redirect_to profile_path
      end
      
      it "should deny access to project 2" do
        get :project2, :id => @project
        response.should redirect_to profile_path
      end
    end
  end
end
