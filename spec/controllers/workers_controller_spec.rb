require 'spec_helper'

describe WorkersController do

  integrate_views
  
  describe "access control" do
    
    describe "for a non signed-in user" do
      it "should deny access to 'index'" do
        get :index
        response.should redirect_to signin_path
      end
    
      it "should deny access to 'new'" do
        get :new
        response.should redirect_to signin_path
      end
    
      it "should deny access to 'edit'" do
        get :edit
        response.should redirect_to signin_path
      end
     
      it "should deny access to 'create'" do
        post :create
        response.should redirect_to signin_path
      end
    
      it "should deny access to 'update'" do
        put :update
        response.should redirect_to signin_path
      end
    
      it "should deny access to 'destroy'" do
        delete :destroy
        response.should redirect_to signin_path
      end
    end
    
    describe "for a non admin user" do
      before(:each) do
        activate_authlogic
        @user = Factory(:user)
        test_sign_in(@user)
      end
      
      it "should deny access to 'index'" do
        get :index
        response.should redirect_to profile_path
      end
    
      it "should deny access to 'new'" do
        get :new
        response.should redirect_to profile_path
      end
    
      it "should deny access to 'edit'" do
        get :edit
        response.should redirect_to profile_path
      end
     
      it "should deny access to 'create'" do
        post :create
        response.should redirect_to profile_path
      end
    
      it "should deny access to 'update'" do
        put :update
        response.should redirect_to profile_path
      end
    
      it "should deny access to 'destroy'" do
        delete :destroy
        response.should redirect_to profile_path
      end
    end
  end
  
  describe "for an admin user" do
    
    before(:each) do
      activate_authlogic
      @admin = Factory(:user, :admin => true)
      test_sign_in(@admin)
      @worker= Factory(:worker, :name => "Billy", :basecamp_id => 2)
      second = Factory(:worker, :name => "Jenny", :basecamp_id => 3)
      third  = Factory(:worker, :name => "Bobby", :basecamp_id => 4)
      @workers =[@worker, second, third]
      10.times do
        @workers << Factory(:worker, :name => Factory.next(:name), :basecamp_id => Factory.next(:basecamp_id))
      end
      Worker.should_receive(:find, :all).and_return(@workers)
    end
    
    describe "GET 'index'" do
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_tag("title", /all workers/i)
      end
      
      it "should have an element for each user" do
        get :index
        @workers.each do |worker|
          response.should have_tag("li", /#{worker.name}/)
        end
      end
      
      it "should have an edit link" do
        get :index
        response.should have_tag("a", "Edit")
      end
        
      it "should have a 'delete' link" do
        get :index
        response.should have_tag("a", "Delete")
      end
    end
  end
end