class WorkersController < ApplicationController
  before_filter :require_user
  before_filter :admin_user
  
  def index
    @title = "All Workers"
    @workers = Worker.find(:all)
  end

  def new
  end

  def create
  end

  def show
  end
  
  def edit
  end

  def update
  end

  def destroy
  end

end
