require 'spec_helper'

describe TutorialsController do
  integrate_views
  
  describe "access control" do
    
    describe "for non signed-in users" do
      
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
    
    describe "for signed-in users" do
      
      before(:each) do
        activate_authlogic
        @user = Factory(:user)
        test_sign_in(@user)
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
    
      describe "GET 'show'" do
     
        before(:each) do
          @tutorial = Factory(:tutorial)
          Tutorial.stub!(:find, @tutorial.id).and_return(@tutorial)
        end

        it "should be successful" do
          get :show, :id => @tutorial
          response.should be_success
        end

        it "should have the right title" do
          get :show, :id => @tutorial
          response.should have_tag("title", /#{@tutorial.name}/i)
        end
        
        it "should not have a link to tutorial index" do
          get :show, :id => @tutorial
          response.should_not have_tag("a", /back/i)
        end

        it "should not have a link to edit" do
          get :show, :id => @tutorial
          response.should_not have_tag("a", /edit/i)
        end

        it "should not have a link to delete" do
          get :show, :id => @tutorial
          response.should_not have_tag("a", /delete/i)
        end
      end
    end
  end
  
  describe "for admin users" do
    
    before(:each) do
      activate_authlogic
      @admin = Factory(:user, :admin => true)
      test_sign_in(@admin)
    end
    
    describe "GET 'show'" do
      
      before(:each) do
        @tutorial = Factory(:tutorial)
        Tutorial.stub!(:find, @tutorial.id).and_return(@tutorial)
      end
      
      it "should have a link to tutorial index" do
        get :show, :id => @tutorial
        response.should have_tag("a", /back/i)
      end
      
      it "should have a link to edit" do
        get :show, :id => @tutorial
        response.should have_tag("a", /edit/i)
      end
      
      it "should have a link to delete" do
        get :show, :id => @tutorial
        response.should have_tag("a", /delete/i)
      end
    end
    
    describe "GET 'index'" do
      it "should be successful" do
        get :index
        response.should be_success
      end
    
      it "should have the right title" do
        get :index
        response.should have_tag("title", /all website tutorial pages/i)
      end
    end
  
    describe "GET 'new'" do
      it "should be successful" do
        get :new
        response.should be_success
      end
    
      it "should have the right title" do
        get :new
        response.should have_tag("title", /add new page/i)
      end
    end
  
    describe "GET 'edit'" do
      before(:each) do
        @tutorial = Factory(:tutorial)
      end
    
      it "should be successful" do
        get :edit, :id => @tutorial
        response.should be_success
      end
  
      it "should have the right title" do
        get :edit, :id => @tutorial
        response.should have_tag("title", /edit page/i)
      end
    end
  
    describe "POST 'create'" do
    
      describe "failure" do
      
        before(:each) do
          @attr = {
            :name => "",
            :category => "",
            :permalink => "",
            :content => "",
            :page_order => ""
          }
          @tutorial = Factory.build(:tutorial, @attr)
          Tutorial.stub!(:new).and_return(@tutorial)
          @tutorial.should_receive(:save).and_return(false)
        end
      
        it "should have the right title" do
          post :create, :tutorial => @attr
          response.should have_tag("title", /add new page/i)
        end
      
        it "should render the 'new' page" do
          post :create, :tutorial => @attr
          response.should render_template('new')
        end
      end
    
      describe "success" do
      
        before(:each) do
          @attr = {
            :name => "Website Setup Overview",
            :category => "website-setup",
            :permalink => "overview",
            :content => "here it is",
            :page_order => "1"
          }
          @tutorial = Factory(:tutorial, @attr)
          Tutorial.stub!(:new).and_return(@tutorial)
          @tutorial.should_receive(:save).and_return(true)
        end
      
        it "should redirect to the website setup show page" do
          post :create, :tutorial => @attr
          response.should redirect_to(tutorial_path(@tutorial))
        end
      end
    end
  
    describe "PUT 'update'" do
    
      before(:each) do
        @tutorial = Factory(:tutorial)
        Tutorial.should_receive(:find).with(@tutorial).and_return(@tutorial)
      end
    
      describe "failure" do
      
        before(:each) do
          @invalid_attr = { :name => "", :permalink => "", :content => "" }
          @tutorial.should_receive(:update_attributes).and_return(false)
        end
      
        it "should render the 'edit' page" do
          put :update, :id => @tutorial, :tutorial => {}
          response.should render_template('edit')
        end
      
        it "should have the right title" do
          put :update, :id => @tutorial, :tutorial => {}
          response.should have_tag("title", /edit page/i)
        end
      end
    
      describe "success" do
      
        before(:each) do
          @attr = {
            :name => "Website Setup Overview",
            :category => "website-setup",
            :permalink => "overview",
            :content => "here it is",
            :page_order => "1"
          }
          @tutorial.should_receive(:update_attributes).and_return(true)
        end
      
        it "should redirect to the user show page" do
          put :update, :id => @tutorial, :tutorial => @attr
          response.should redirect_to(tutorial_path(@tutorial))
        end
      
        it "should have a flash message" do
          put :update, :id => @tutorial, :tutorial => @attr
          flash[:success].should =~ /updated/i
        end
      end
    end
  
    describe "DELETE 'destroy'" do
    
      before(:each) do
        @tutorial = Factory(:tutorial)
      end
    
      it "should destroy the page" do      
        Tutorial.should_receive(:find).with(@tutorial).and_return(@tutorial)
        @tutorial.should_receive(:destroy).and_return(@tutorial)
        delete :destroy, :id => @tutorial
        response.should redirect_to(tutorials_path)
        flash[:success].should =~ /page deleted/i
      end
    end
  end
  
  describe "website-setup"
  
  describe "keyword-research"
  
  describe "creating-content"
  
  describe "getting-backlinks"
    
    
end
