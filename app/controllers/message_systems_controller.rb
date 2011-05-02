class MessageSystemsController < ApplicationController
	layout "message"
	def new
		if params[:subject]
			params[:subject] = "RE: "+params[:subject]
		end
		@message = current_user.sent_messages.new( :receiver_id => params[:send_to], :subject => params[:subject] )
		@inbox = current_user.inbox_messages
		@sent = current_user.sent_messages
	end

	def create
		@message = current_user.sent_messages.new( params[:message_system] )
		@message.save
		@message.message_id = @message.id
		@message.save
		flash[:success] = "Message Sent!"
		redirect_to root_url
	
	end

	def show
		@message = MessageSystem.find( params[:id] )
		@inbox = current_user.inbox_messages
		@sent = current_user.sent_messages
	end

	def index
		@inbox = current_user.inbox_messages
		@sent = current_user.sent_messages
	end
end
