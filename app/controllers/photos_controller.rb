class PhotosController < ApplicationController
  def index
  end

  def new
  end

	def create
  end  

	def show
		@photo = Photo.find(params[:id])
		@photo.destroy
		flash[:success] = "Photo Removed"
		redirect_to name_path( @network, {:name => params[:name], :tab=>"Media"})
  end

  def destroy
  end

end
