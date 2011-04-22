class WebsitesController < ApplicationController
  before_filter :require_user, :only => [:new, :edit, :create, :update, :destroy]
  before_filter :authorized_user, :only => [:edit, :update, :destroy]
  
  def new
    @title = "Add New Website"
    @website = Website.new
  end
  
  def edit
    @title = "Edit Website"
    @website = Website.find(params[:id])
  end
  
  def create
    @website = current_user.websites.build(params[:website])
    if @website.save
      flash[:success] = "Website Added!"
      redirect_to profile_path
    else
      @title = "Add New Website"
      render 'new'
    end
  end

  def update
    if @website.update_attributes(params[:website])
      flash[:success] = "Website successfully updated"
      redirect_to profile_path
    else
      @title = "Edit Website"
      render "edit"
    end
  end
  
  def destroy
    @website.destroy
    redirect_to profile_path
  end
  
  private
  
    def authorized_user
      @website = Website.find(params[:id])
      redirect_to root_path unless current_user?(@website.user)
    end
  
end
