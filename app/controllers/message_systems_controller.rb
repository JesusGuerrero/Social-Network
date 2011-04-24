class MessageSystemsController < ApplicationController

	def new
		@message = current_user.sent_messages.new( :receiver_id => params[:send_to] )
	end

	def create
		@message = current_user.sent_messages.new( params[:message_system] )
		@message.save
		@message.message_id = @message.id
		@message.save
		flash[:success] = "Message Sent!"
		redirect_to root_url
	
	end

	def index
		@inbox = current_user.inbox_messages
		@sent = current_user.sent_messages
	end
end
