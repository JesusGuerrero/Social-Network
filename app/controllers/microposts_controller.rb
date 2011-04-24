class MicropostsController < ApplicationController
  def index
  end

  def new
		@micropost = current_user.microposts.new(:network_id => params[:id])
  end

  def create
		@micropost = current_user.microposts.create!( params[:micropost] )
		@micropost.save
		@micropost.micropost_id = @micropost.id
		@micropost.save

		flash[:success] = "Posted Successfully"

		redirect_to root_path
  end

	def destroy
    @post = Micropost.find(params[:id])
		@post.destroy
    flash[:success] = "Micropost Destroyed"
    redirect_to root_path
  end

end
