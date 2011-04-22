class KeywordsController < ApplicationController
  before_filter :require_user, :only => [:new, :edit, :create, :update, :destroy]
  before_filter :authorized_user, :only => [:edit, :update, :destroy]
  
  def new
    @title = "Add New Keyword"
    @keyword = Keyword.new
    # @content = @keyword.build_content
  end
  
  def edit
    @title = "Edit Keyword"
    @content = @keyword.content || @keyword.build_content
  end
  
  def create
    @keyword = current_user.keywords.build(params[:keyword])
    if @keyword.save
      flash[:success] = "Keyword Added!"
      redirect_to profile_path
    else
      @title = "Add New Keyword"
      render 'new'
    end
  end
  
  def update
    if @keyword.update_attributes(params[:keyword])
      flash[:success] = "Keyword successfully updated"
      redirect_to profile_path
    else
      @title = "Edit Keyword"
      render "edit"
    end
  end
  
  def destroy
    @keyword.destroy
    redirect_to profile_path
  end
  
  private
  
    def authorized_user
      @keyword = Keyword.find(params[:id])
      redirect_to root_path unless current_user?(@keyword.user)
    end
end