class PagesController < ApplicationController
	

	def about
		render :layout => "user_session"
	end
	
	def terms
		render :layout => "user_session"
	end

	def privacy
		render :layout => "user_session"
	end

	def feedback
		render :layout => "user_session"
	end

	def contact
		render :layout => "user_session"
	end
end
