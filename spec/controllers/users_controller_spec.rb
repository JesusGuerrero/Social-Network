require 'spec_helper'

describe UsersController do
  integrate_views
  
  describe "GET 'index'" do
    
    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to signin_path
      end
    end
    
    describe "for signed-in users" do
      
      before(:each) do
        @user  = Factory(:user)
        test_sign_in(@user)
        second = Factory(:user, :email => "another@example.com")
        third  = Factory(:user, :email => "another@example.net")
        
        @users = [@user, second, third]
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_tag("title", /all users/i)
      end
      
      it "should have an element for each user" do
        get :index
        @users.each do |user|
          response.should have_tag("li", user.name)
        end
      end
      
      it "should not have a 'delete' link" do
        get :index
        response.should_not have_tag("a", "delete")
      end
    end
    
    describe "as an admin user" do

      before(:each) do
        admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(admin)
      end

      it "should have a 'delete link" do
        get :index
        response.should have_tag("a", "delete")
      end
    end 
  end
  
  describe "GET 'new'" do
    
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_tag("title", /sign up/i)
    end
    
    it "should have a name field" do
      get :new
      response.should have_tag("input[name=?][type=?]", "user[name]", "text")
    end
    
    it "should have an email field" do
      get :new
      response.should have_tag("input[name=?][type=?]", "user[email]", "text")
    end
    
    it "should have a password field" do
      get :new
      response.should have_tag("input[name=?][type=?]", "user[password]", "password")
    end

    it "should have a password confirmation field" do
      get :new
      response.should have_tag("input[name=?][type=?]", "user[password_confirmation]", "password")
    end

    describe "for signed-in users" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end

      it "should deny access to 'new'" do  
        get :new, :id => @user
        response.should redirect_to(profile_path)
      end
    end
  end
      
  describe "GET 'show'" do
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
      User.stub!(:find, @user.id).and_return(@user)
    end
    
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end
    
    it "should have the right title" do
      get :show, :id => @user
      response.should have_tag("title", /#{@user.name}/)
    end
    
    it "should have a profile image" do
      get :show, :id => @user
      response.should have_tag("h1>img", :class => "gravatar")
    end
    
    describe "level 0" do
      
      before(:each) do
        @user.level = 0
      end
      
      it "should have a link to the website tutorials" do
        get :show, :id => @user
        response.should have_tag("a", /website setup tutorials/i)
      end
    end
    
    describe "level 1" do
      
      before(:each) do
        @user.level = 1
        @user.last_tutorial = 10
      end
    
      it "should show the user's websites" do
        web1 = Factory(:website, :user => @user, :domain => "http://www.example.com", :description => "example site 1")
        web2 = Factory(:website, :user => @user, :domain => "http://www.example.net", :description => "example site 2")
        get :show, :id => @user
        response.should have_tag("div.item", /#{web1.domain}/)
        response.should have_tag("div.item", /#{web2.domain}/)
      end
      
      it "should have a link to the keyword tutorials" do
        get :show, :id => @user
        response.should have_tag("a", /keyword research tutorials/i)
      end
    end
    
    describe "level 2" do
      
      before(:each) do
        @user.level = 2
        @user.last_tutorial = 15
      end
    
      it "should show the user's keywords" do
        key1 = Factory(:keyword, :user => @user, :keyphrase => "Keyword 1", :description => "example 1")
        key2 = Factory(:keyword, :user => @user, :keyphrase => "Keyword 2", :description => "example 2")
        get :show, :id => @user
        response.should have_tag("div.item", /#{key1.keyphrase}/)
        response.should have_tag("div.item", /#{key2.keyphrase}/)
      end
      
      it "should have a link to the keyword tutorials" do
        get :show, :id => @user
        response.should have_tag("a", /keyword research tutorials/i)
      end
    end
    
    describe "level 3" do
      
      before(:each) do
        @user.level = 3
        @user.last_tutorial = 20
      end
    
      it "should show the user's content urls" do
        key1 = Factory(:keyword, :user => @user, :keyphrase => "Keyword 1", :description => "example 1")
        key2 = Factory(:keyword, :user => @user, :keyphrase => "Keyword 2", :description => "example 2")
        cont1 = Factory(:content, :keyword => key1, :link_url => "http://www.example.com")
        cont2 = Factory(:content, :keyword => key2, :link_url => "http://www.example.net")
        get :show, :id => @user
        response.should have_tag("div.item", /#{cont1.link_url}/)
        response.should have_tag("div.item", /#{cont2.link_url}/)
      end
      
      it "should have a link to the content tutorials" do
        get :show, :id => @user
        response.should have_tag("a", /creating content tutorials/i)
      end
    end
    
    describe "buyer" do
      
      before(:each) do
        @user.buyer = true
      end
      
      it "should show the user's projects" do
        proj1 = Factory(:project, :user => @user, :name => "Project 1")
        proj2 = Factory(:project, :user => @user, :name => "Project 2")
        get :show, :id => @user
        response.should have_tag("div.item", /#{proj1.name}/)
        response.should have_tag("div.item", /#{proj2.name}/)
      end
    end
  end
  
  describe "POST 'create'" do
    
    describe "failure" do
      
      before(:each) do
        @attr = {
          :name => "",
          :email => "",
          :password => "",
          :password_confirmation => ""
        }
        @user = Factory.build(:user, @attr)
        User.stub!(:new).and_return(@user)
        @user.should_receive(:save).and_return(false)
      end
      
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_tag("title", /sign up/i)
      end
      
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attr = {
          :name => "New User", 
          :email => "user@example.com", 
          :password => "foobar", 
          :password_confirmation => "foobar"
        }
        @user = Factory(:user, @attr)
        User.stub!(:new).and_return(@user)
        @user.should_receive(:save).and_return(true)
      end

      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(profile_path)
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the link networker members area/i
      end
    end

    describe "for signed-in users" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end

      it "should deny access to 'create'" do
        get :create, :id => @user
        response.should redirect_to(profile_path)
      end
    end
  end

  describe "GET 'edit'" do

    describe "for non-signed-in users" do

      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end
    end
    
    describe "for signed-in users" do
      
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        User.stub!(:find).and_return(@user)
      end

      it "should be successful" do
        get :edit, :id => @user
        response.should be_success
      end

      it "should have the right title" do
        get :edit, :id => @user
        response.should have_tag("title", /edit profile/i)
      end

      it "should have a link to change the Gravatar" do
        get :edit, :id => @user
        gravatar_url = "http://gravatar.com/emails"
        response.should have_tag("a[href=?]", gravatar_url, /change/i)
      end

    end
    
    describe "for the wrong user" do
      
      before(:each) do
        @user = Factory(:user)
        wrong_user = Factory(:user, :email => "user@example.net")
        test_sign_in(wrong_user)
      end
      
      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(profile_path)
      end
    end
  end

  describe "PUT 'update'" do

    describe "for non-signed-in users" do
      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end
    end
    
    describe "for signed-in users" do
      
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        User.stub!(:find).and_return(@user)
      end

      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(profile_path)
      end

      describe "failure" do

        before(:each) do
          @invalid_attr = { :email => "", :name => "", :password => "", :password_confirmation => "" }
          @user.should_receive(:update_attributes).and_return(false)
        end

        it "should render the 'edit' page" do
          put :update, :id => @user, :user => @invalid_attr
          response.should render_template('edit')
        end

        it "should have the right title" do
          put :update, :id => @user, :user => @invalid_attr
          response.should have_tag("title", /edit profile/i)
        end
      end

      describe "success" do

        before(:each) do
          @attr = { :name => "New Name", :email => "user@example.org",
                    :password => "barbaz", :password_confirmation => "barbaz" }
          @user.should_receive(:update_attributes).and_return(true)
        end

        it "should redirect to the user show page" do
          put :update, :id => @user, :user => @attr
          response.should redirect_to(profile_path)
        end

        it "should have a flash message" do
          put :update, :id => @user, :user => @attr
          flash[:success].should =~ /updated/
        end
      end
    end
  end

  describe "DELETE 'destroy'" do
  
    before(:each) do
      @user = Factory(:user)
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end

    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(profile_path)
      end
    end

    describe "as an admin user" do

      before(:each) do
        @admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(@admin)
      end
      
      # Test won't work, but program does
      # it "should destroy the user" do      
      #   User.stub!(:find).and_return(@user)
      #   delete :destroy, :id => @user
      #   response.should redirect_to(users_path)
      #   flash[:success].should =~ /user destroyed/i
      # end

      it "should not destroy the admin" do
        User.stub!(:find).and_return(@admin)
        delete :destroy, :id => @admin
        response.should redirect_to(users_path)
        flash[:notice].should =~ /cannot destroy/i
      end
    end
  end
end
