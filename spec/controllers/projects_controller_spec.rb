require 'spec_helper'

describe ProjectsController do

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
    
    describe "for an unauthorized user" do
      before(:each) do
        activate_authlogic
        @user = Factory(:user)
        @wrong_user = Factory(:user, :email => "wrong@example.com")
        test_sign_in(@wrong_user)
        @attr = {
          :active => false
        }
        @project = Factory(:project, @attr.merge(:user => @user))
      end
      
      it "should deny access to edit" do
        get :edit, :id => @project
        response.should redirect_to(root_path)
      end
      
      it "should deny access to update" do
        put :update, :id => @project, :project => @attr
        response.should redirect_to(root_path)
      end
      
      it "should deny access to destroy" do
        delete :destroy, :id => @project
        response.should redirect_to(root_path)
      end
    end 
  end
  
  describe "GET 'index'" do
    before(:each) do
      activate_authlogic
      @admin = Factory(:user, :admin => true)
      test_sign_in(@admin)
    end
    
    it "should allow access to 'index'" do
      get :index
      response.should be_success
    end
    
    it "should have the right title" do
      get :index
      response.should have_tag("title", /all projects/i)
    end
  end
  
  describe "GET 'show'" do
    
    before(:each) do
      activate_authlogic
      @user = Factory(:user)
      @project = Factory(:project, :user => @user)
      key1 = Factory(:keyword, :user => @user, :keyphrase => "Keyword 1", :description => "example 1")
      key2 = Factory(:keyword, :user => @user, :keyphrase => "Keyword 2", :description => "example 2")
      key3 = Factory(:keyword, :user => @user, :keyphrase => "Keyword 3", :description => "example 3")
      cont1 = Factory(:content, :keyword => key1, :link_url => "http://www.example.com")
      cont2 = Factory(:content, :keyword => key2, :link_url => "http://www.example.net")
      cont3 = Factory(:content, :keyword => key3, :link_url => "http://www.example.org")
      @keywords = [key1, key2, key3]
      Project.stub!(:find).and_return(@project)
      @project.stub!(:keywords).and_return(@keywords)
    end
    
    it "should be successful" do
      get :show
      response.should be_success
    end
    
    it "should have the right title" do
      get :show
      response.should have_tag("title", /#{@project.name}/)
    end
    
    it "should have the project name" do
      get :show
      response.should have_tag("p", /#{@project.name}/)
    end
    
    it "should have the project description" do
      get :show
      response.should have_tag("p", /#{@project.description}/)
    end

    it "should have an element for each keyword" do
      get :show
      @project.keywords.each do |keyword|
        response.should have_tag("td", keyword.keyphrase)
      end
    end
    
    it "should have an edit link" do
      get :show
      response.should have_tag("a", "Edit")
    end
    
    it "should have a delete link" do
      get :show
      response.should have_tag("a", "Delete")
    end
  
    describe "for an admin" do
      before(:each) do
        @admin = Factory(:user, :email => "joseph.oday@example.com", :admin => "true")
        test_sign_in(@admin)
        @writer.stub!(:first_name).and_return("Joseph")
      end
      
      it "should have the current writer" do
        get :show
        response.should have_tag("p", /#{@writer.first_name}/)
      end
      
      it "should have the current linker" do
        get :show
        response.should have_tag("p", /#{@linker.first_name}/)
      end
      
      it "should have a link to basecamp" do
        get :show
        response.should have_tag("a", /view in basecamp/i)
      end
      
      it "should have a notes section" do
        get :show
        response.should have_tag("p", /#{@project.notes}/)
      end
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
      response.should have_tag("title", /add new linking project/i)
    end
  end

  describe "POST 'create'" do
      
    before(:each) do
      activate_authlogic
      @user = Factory(:user)
      @attr = {
        :name => "test",
        :active => "false",
        :basecamp_id => "5723374",
        :writer_id => "5004530",
        :linker_id => "5004530",
        :description => "test project description",
        :notes => "PR 0",
        :active => "false"
      }
      # 5723374 is test, 5004530 is Joseph O'Day
      @project = Factory(:project, @attr.merge(:user => @user))
      @keyword = Factory(:keyword, :user => @user)
      Keyword.stub!(:find_by_id, @keyword.id).and_return(@keyword)
      controller.stub!(:current_user).and_return(@user)
      @user.projects.stub!(:build).and_return(@project)
    end
    
    describe "failure" do
      
      before(:each) do
        @project.should_receive(:save).and_return(false)
      end
      
      it "should render the 'new' page" do
        post :create, :project => @attr
        response.should render_template('projects/new')
      end
    end
    
    describe "success" do
      
      before(:each) do
        @project.should_receive(:save).and_return(true)
      end
      
      it "should redirect to the profile page" do
        post :create, :project => @attr
        response.should redirect_to(profile_path)
      end
      
      it "should have a flash message" do
        post :create, :project => @attr
        flash[:success].should =~ /project added/i
      end
    end
  end
  
  describe "GET 'edit" do
    before(:each) do
      activate_authlogic
      @user = Factory(:user)
      @project = Factory(:project, :user => @user)
      Project.stub!(:find, @project.id).and_return(@project)
    end
  
    it "should be successful" do
      get :edit, :id => @project
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @project
      response.should have_tag("title", /edit linking project/i)
    end
    
    it "should have the project name" do
      get :edit, :id => @project
      response.should have_tag("div", /#{@project.name}/)
    end
    
    it "should have a description text box" do
      get :edit, :id => @project
      response.should have_tag("textarea[id=?][name=?]", "project_description", "project[description]")
    end
    
    describe "for an admin" do
      before(:each) do
        @admin = Factory(:user, :admin => true)
        test_sign_in(@admin)     
      end
      
      it "should have the client name" do
        get :edit, :id => @project
        response.should have_tag("div", /#{@project.user.name}/)
      end
      
      it "should have an active select box" do
        get :edit, :id => @project
        response.should have_tag("select[id=?][name=?]", "project_active", "project[active]")
      end
      
      it "should have a basecamp id select box" do
        get :edit, :id => @project
        response.should have_tag("select[id=?][name=?]", "project_basecamp_id", "project[basecamp_id]")
      end
      
      it "should have a writer select box" do
        get :edit, :id => @project
        response.should have_tag("select[id=?][name=?]", "project_writer_id", "project[writer_id]")
      end
      
      it "should have a linker select box" do
        get :edit, :id => @project
        response.should have_tag("select[id=?][name=?]", "project_linker_id", "project[linker_id]")
      end
      
      it "should have a notes text field" do
        get :edit, :id => @project
        response.should have_tag("textarea[id=?][name=?]", "project_notes", "project[notes]")
      end
    end
  end
  
  describe "PUT 'update'" do
    
    before(:each) do
      activate_authlogic
      @user = Factory(:user)
      @attr = {
        :active => false
      }
      @project = Factory(:project, @attr.merge(:user => @user))
      Project.stub!(:find).with(@project).and_return(@project)
    end
    
    describe "failure" do
      
      before(:each) do
        @project.should_receive(:update_attributes).and_return(false)
      end
      
      it "should be render the 'edit' page" do
        put :update, :id => @project, :project => {}
        response.should render_template('edit')
      end
      
      it "should have the right title" do
        put :update, :id => @project, :project => {}
        response.should have_tag("title", /edit linking project/i)
      end
    end
    
    describe "success" do
      
      before(:each) do
        @project.should_receive(:update_attributes).and_return(true)
      end
      
      it "should redirect to the profile page" do
        put :update, :id => @project, :project => @attr
        response.should redirect_to(profile_path)
      end
      
      it "should have a flash message" do
        put :update, :id => @project, :project => @attr
        flash[:success].should =~ /updated/
      end
    end
    
    describe "for an admin" do
      before(:each) do
        activate_authlogic
        @admin = Factory(:user, :admin => true)
        test_sign_in(@admin)
      end
      
      describe "failure" do

        before(:each) do
          @project.should_receive(:update_attributes).and_return(false)
        end
        
        it "should be render the 'edit' page" do
          put :update, :id => @project, :project => {}
          response.should render_template('edit')
        end

        it "should have the right title" do
          put :update, :id => @project, :project => {}
          response.should have_tag("title", /activate linking project/i)
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
        @project = Factory(:project, :user => @user)
      end
      
      it "should deny access" do
        @project.should_not_receive(:destroy)
        delete :destroy, :id => @project
        response.should redirect_to(root_path)
      end
    end
    
    describe "for an authorized user" do 
      before(:each) do
        activate_authlogic
        @user = Factory(:user)
        test_sign_in(@user)
        @project = Factory(:project, :user => @user)
        Project.should_receive(:find).with(@project).and_return(@project)
      end
      
      it "should destroy the project" do
        @project.should_receive(:destroy).and_return(@project)
        delete :destroy, :id => @project
      end
      
      it "should redirect to the profile page" do
        @project.should_receive(:destroy).and_return(@project)
        delete :destroy, :id => @project
        response.should redirect_to(profile_path)
      end
    end
    
    describe "for an admin user" do
      before(:each) do
        activate_authlogic
        @admin = Factory(:user, :admin => true)
        @user = Factory(:user)
        test_sign_in(@admin)
        @project = Factory(:project, :user => @user)
        Project.should_receive(:find).with(@project).and_return(@project)
      end
      
      it "should destroy the project" do
        @project.should_receive(:destroy).and_return(@project)
        delete :destroy, :id => @project
      end
      
      it "should redirect to the profile page" do
        @project.should_receive(:destroy).and_return(@project)
        delete :destroy, :id => @project
        response.should redirect_to(projects_path)
      end
    end
  end
end
