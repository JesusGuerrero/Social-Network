require 'spec_helper'

describe WebsitesController do
  integrate_views
  
  describe "access control" do
    
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
  
  describe "GET 'new'" do
    
    before(:each) do
      activate_authlogic
      @user = Factory(:user)
    end
    
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_tag("title", /add new website/i)
    end
    
    it "should have a domain field" do
      get :new
      response.should have_tag("input[name=?][type=?]", "website[domain]", "text")
    end
    
    it "should have a description field" do
      get :new
      response.should have_tag("textarea[name=?]", "website[description]")
    end
  end
  
  describe "POST 'create'" do
    
    before(:each) do
      activate_authlogic
      @user = Factory(:user)
      @attr = {
        :domain => "http://www.example.com",
        :description => "example site"
      }
      @website = Factory(:website, @attr.merge(:user => @user))
      controller.stub!(:current_user).and_return(@user)
      @user.websites.stub!(:build).and_return(@website)
    end
    
    describe "failure" do
      
      before(:each) do
        @website.stub!(:save).and_return(false)
      end
      
      it "should render the 'new' page" do
        post :create, :website => @attr
        response.should render_template('new')
      end
    end
    
    describe "success" do
      
      before(:each) do
         @website.stub!(:save).and_return(true)
      end
      
      it "should redirect to the profile page" do
        post :create, :website => @attr
        response.should redirect_to(profile_url)
      end
      
      it "should have a flash message" do
        post :create, :website => @attr
        flash[:success].should =~ /website added/i
      end
    end
  end
  
  describe "PUT 'update'" do
    
    before(:each) do
      activate_authlogic
      @attr = {
        :domain => "http://www.example.com",
        :description => "example site"
      }
      @website = Factory(:website)
      Website.stub!(:find).and_return(@website)
    end
    
    describe "for an unauthorized user" do
      
      before(:each) do
        @user = Factory(:user)
        wrong_user = Factory(:user, :email => "wronguser@example.net")
        test_sign_in(wrong_user)
      end
      
      it "should deny access" do
        @website.should_not_receive(:destroy)
        delete :destroy, :id => @website
        response.should redirect_to(root_path)
      end
    end
    
    describe "for an authorized user" do
      
      describe "failure" do
      
        before(:each) do
          @invalid_attr = { :domain => "", :description => "" }
          @website.should_receive(:update_attributes).and_return(false)
        end
      
        it "should be render the 'edit' page" do
          put :update, :id => @website, :website => {}
          response.should render_template('edit')
        end
      
        it "should have the right title" do
          put :update, :id => @website, :website => {}
          response.should have_tag("title", /edit website/i)
        end
      end
    
      describe "success" do
      
        before(:each) do
          @website.should_receive(:update_attributes).and_return(true)
        end
      
        it "should redirect to the profile page" do
          put :update, :id => @website, :website => @attr
          response.should redirect_to(profile_path)
        end
      
        it "should have a flash message" do
          put :update, :id => @website, :website => @attr
          flash[:success].should =~ /updated/
        end
      end
    end
  end
  
  describe "DELETE 'destroy'" do
    
    describe "for an unauthorized user" do
      
      before(:each) do
        activate_authlogic
        @user = Factory(:user)
        wrong_user = Factory(:user, :email => "wronguser@example.net")
        test_sign_in(wrong_user)
        @website = Factory(:website, :user => @user)
      end
      
      it "should deny access" do
        @website.should_not_receive(:destroy)
        delete :destroy, :id => @website
        response.should redirect_to(root_path)
      end
    end
    
    describe "for an authorized user" do
      
      before(:each) do
        activate_authlogic
        @user = Factory(:user)
        test_sign_in(@user)
        @website = Factory(:website, :user => @user)
        Website.should_receive(:find).with(@website).and_return(@website)
      end
      
      it "should destory the website" do
        @website.should_receive(:destroy).and_return(@website)
        delete :destroy, :id => @website
      end
    end
  end
end
