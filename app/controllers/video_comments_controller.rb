class VideoCommentsController < ApplicationController
  def _new
  end

  def create
		@video = Video.find(params[:v_id])
		if @video.video_comments.create!(params[:video_comment])
			flash[:success] = "Comment Success"
			redirect_to name_path( @network, {:name => params[:name], :tab=>"Media", :video => "show", :v_id => params[:v_id]})
		else
			flash[:error] = "Maximum 255 characters allowed for comments."
			redirect_to name_path( @network, {:name => params[:name], :tab=>"Media", :video => "show", :v_id => params[:v_id]})

		end
  end

	def show
		@video = VideoComment.find(params[:id])
		@video.destroy
		flash[:success] = "Comment Removed"
		redirect_to name_path( @network, {:name => params[:name], :tab=>"Media", :video => "show", :v_id => params[:v_id]})
	end

end
