class ShoppingCartController < ApplicationController
  def listener
		if params[:id]
			#@user = User.find(params[:id])
			#@user.deliver_test_instructions!
		end
		@tmp = "123"
		deliver_listener_instructions!
  end

	def deliver_listener_instructions!
		Notifier.deliver_listening_event()
	end

	def send_request
		apiKey = "49a7bbd29d784d6185135dbc058f13b0"
		uri = "https://www.mcssl.com/API/170111/Notifications/TEST"

		
	end
end
