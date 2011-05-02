class VideosController < ApplicationController
  def index
  end

  def new
		@video = current_user.videos.new(:network_id => params[:id])
  end

	def create
		@video = Video.new(params[:video])
		@video.save
		redirect_to name_path( @network, {:name => params[:name], :tab=>"Media"})
  end  

	def show
		@video = Video.find(params[:id])
		@video.destroy
		flash[:success] = "Video Removed"
		redirect_to name_path( @network, {:name => params[:name], :tab=>"Media"})
  end

  def destroy
  end

end
