require 'spec_helper'

describe KeywordsController do
  
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
      response.should have_tag("title", /add new keyword/i)
    end
    
    it "should have a domain field" do
      get :new
      response.should have_tag("input[name=?][type=?]", "keyword[keyphrase]", "text")
    end
    
    it "should have a description field" do
      get :new
      response.should have_tag("textarea[name=?]", "keyword[description]")
    end
    
    # describe "for a level 3 user" do
    #   before(:each) do
    #     @user.level = 4
    #   end
    #   
    #   it "should have a url field" do
    #     get :new
    #     response.should have_tag("input[name=?][type=?]", "contents[link_url]", "text")
    #   end
    # end
  end
  
  describe "POST 'create'" do
    
    before(:each) do
      @user = Factory(:user)
      @attr = {
        :keyphrase => "keyword 1",
        :description => "keyword 1 description"
      }
      @keyword = Factory(:keyword, @attr.merge(:user => @user))
      controller.stub!(:current_user).and_return(@user)
      @user.keywords.stub!(:build).and_return(@keyword)
    end
    
    describe "failure" do
      
      before(:each) do
        @keyword.should_receive(:save).and_return(false)
      end
      
      it "should render the 'new' page" do
        post :create, :keyword => @attr
        response.should render_template('keywords/new')
      end
    end
    
    describe "success" do
      
      before(:each) do
        @keyword.should_receive(:save).and_return(true)
      end
      
      it "should redirect to the profile page" do
        post :create, :keyword => @attr
        response.should redirect_to(profile_path)
      end
      
      it "should have a flash message" do
        post :create, :keyword => @attr
        flash[:success].should =~ /keyword added/i
      end
    end
  end

  describe "PUT 'update'" do
    
    before(:each) do
      activate_authlogic
      @keyword = Factory(:keyword)
      Keyword.stub!(:find).with(@keyword).and_return(@keyword)
    end
    
    describe "failure" do
      
      before(:each) do
        @invalid_attr = { :keyphrase => "", :description => "" }
        @keyword.should_receive(:update_attributes).and_return(false)
      end
      
      it "should be render the 'edit' page" do
        put :update, :id => @keyword, :keyword => {}
        response.should render_template('edit')
      end
      
      it "should have the right title" do
        put :update, :id => @keyword, :keyword => {}
        response.should have_tag("title", /edit keyword/i)
      end
    end
    
    describe "success" do
      
      before(:each) do
        @keyword.should_receive(:update_attributes).and_return(true)
      end
      
      it "should redirect to the profile page" do
        put :update, :id => @keyword, :keyword => @attr
        response.should redirect_to(profile_path)
      end
      
      it "should have a flash message" do
        put :update, :id => @keyword, :keyword => @attr
        flash[:success].should =~ /updated/
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
        @keyword = Factory(:keyword, :user => @user)
      end
      
      it "should deny access" do
        @keyword.should_not_receive(:destroy)
        delete :destroy, :id => @keyword
        response.should redirect_to(root_path)
      end
    end
    
    describe "for an authorized user" do
      
      before(:each) do
        activate_authlogic
        @user = Factory(:user)
        test_sign_in(@user)
        @keyword = Factory(:keyword, :user => @user)
        Keyword.should_receive(:find).with(@keyword).and_return(@keyword)
      end
      
      it "should destory the keyword" do
        @keyword.should_receive(:destroy).and_return(@keyword)
        delete :destroy, :id => @keyword
      end
    end
  end
end