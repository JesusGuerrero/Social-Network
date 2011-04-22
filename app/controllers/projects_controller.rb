class ProjectsController < ApplicationController
  require 'lib/basecamp.rb'
  
  before_filter :require_user, :only => [:index, :new, :edit, :create, :update, :destroy]
  before_filter :authorized_user, :only => [:edit, :update, :destroy]
  before_filter :admin_user, :only => [:index]
  before_filter :build_project, :only => [:create]
  before_filter :update_project, :only => [:update]
  before_filter :retrieve_projects_workers, :only => [:edit]

  def index
    @projects = Project.find(:all, :order => "active DESC")
    @title = "All Projects"
  end
  
  def show
    @project = Project.find(params[:id])
    @keywords = @project.keywords
    @title = CGI.escapeHTML(@project.name)
    
    unless @project.basecamp_id == nil
      get_milestones(@project.basecamp_id)
    end
    
    if current_user.admin?
      get_worker
    end
  end
  
  def new
    @project = Project.new
    @title = "Add New Linking Project"
    @user = current_user
    @keywords = @user.keywords
  end
  
  def create
    if @project.save
      flash[:success] = "Project added!"
      redirect_to profile_path
    else
      @title = "Add New Linking Project"
      @keywords = current_user.keywords
      render 'projects/new'
    end
  end
  
  def edit
    @title = "Edit Linking Project"
    @user = @project.user
    @keywords = @user.keywords
  end
  
  def update
    if @project.update_attributes(params[:project])
      flash[:success] = "Project successfully updated"
      if current_user.admin?
        redirect_to projects_path
      else
        redirect_to(profile_url)
      end
    else
      if current_user.admin?
        @title = "Activate Linking Project"
      else
        @title = "Edit Linking Project"
      end
      @keywords = @project.keywords
      render "projects/edit"
    end
  end
  
  def destroy
    @project.destroy
    if current_user.admin?
      redirect_to projects_path
    else
      redirect_to profile_path
    end
  end
  
  private
    def authorized_user
      @project = Project.find(params[:id])
      redirect_to root_path unless current_user?(@project.user) || current_user.admin?
    end
    
    def build_project
      params[:project] ||= { }
      keyword_ids = params[:project].delete('keywords')
      @project = current_user.projects.build(params[:project])
      @project.keywords = Keyword.find_all_by_id(keyword_ids)
    end
    
    def update_project
      @project = Project.find(params[:id])
      keyword_ids = params[:project].delete('keywords')
      @project.keywords = Keyword.find_all_by_id(keyword_ids)
    end
    
    def retrieve_projects_workers
      if current_user.admin?
        basecamp_connect
        @bc_projects = Basecamp::Project.find(:all)
        for i in 0..@bc_projects.length-1 do
          if @bc_projects[i].status != 'active'# or Project.find_by_basecamp_id(@bc_projects[i].id)
            @bc_projects[i] = nil
          end
        end
        @bc_projects.compact!
      
        @bc_people = @basecamp.people(1777202)
        # 1777202 is "LinkNetworker" company
      end
    end
    
    def get_worker
      basecamp_connect
      @writer = @basecamp.person(@project.writer_id)
      @linker = @basecamp.person(@project.linker_id)
    end
    
    def get_milestones(proj_id)
      basecamp_connect
      @tds = Basecamp::TodoList.all(proj_id)
      @mss = @basecamp.milestones(proj_id)
    end
end
