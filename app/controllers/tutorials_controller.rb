class TutorialsController < ApplicationController
  before_filter :require_user
  before_filter :admin_user, :only => [:index, :new, :edit, :create, :update, :destroy]
  
  def index
    @tutorials = Tutorial.find(:all, :order => "page_order")
    @title = "All Website Tutorial Pages"
  end

  def show
    if params[:permalink]
      @tutorial = Tutorial.find_by_permalink(params[:permalink])
      raise ActiveRecord::RecordNotFound, "Page not found" if @tutorial.nil?
    else
      @tutorial = Tutorial.find(params[:id])
    end
    @title = @tutorial.name
  end

  def new
    @tutorial = Tutorial.new
    @title = "Add New Page"
  end

  def edit
    @tutorial = Tutorial.find(params[:id])
    @title = "Edit Page"
  end

  def create
    @tutorial = Tutorial.new(params[:tutorial])
    if @tutorial.save
      flash[:success] = "Page successfully created"
      redirect_to @tutorial
    else
      @title = "Add New Page"
      render "new"
    end
  end

  def update
    @tutorial = Tutorial.find(params[:id])
    if @tutorial.update_attributes(params[:tutorial])
      flash[:success] = "Page successfully updated"
      redirect_to @tutorial
    else
      @title = "Edit Page"
      render "edit"
    end
  end

  def destroy
    @tutorial = Tutorial.find(params[:id])
    @tutorial.destroy
    flash[:success] = "Page Deleted"
    redirect_to tutorials_path
  end
end
