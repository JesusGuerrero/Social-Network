class PhotoCommentsController < ApplicationController
  def new
  end

  def create
		@photo = Photo.find(params[:p_id])
		if @photo.photo_comments.create!(params[:photo_comment])
			flash[:success] = "Comment Success"
			redirect_to name_path( @network, {:name => params[:name], :tab=>"Media", :photo => "show", :p_id => params[:p_id]})
		else
			flash[:error] = "Maximum 255 characters allowed for comments."
			redirect_to name_path( @network, {:name => params[:name], :tab=>"Media", :photo => "show", :p_id => params[:p_id]})

		end
  end
	def show
		@photo = PhotoComment.find(params[:id])
		@photo.destroy
		flash[:success] = "Comment Removed"
		redirect_to name_path( @network, {:name => params[:name], :tab=>"Media", :photo => "show", :p_id => params[:p_id]})
	end

end
