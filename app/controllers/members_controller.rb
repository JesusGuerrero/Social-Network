class MembersController < ApplicationController

	def index
		
	end

	def users
		@members = current_user.networks
		@users = Array.new
		@members.each do  |m|
			@usr = m.users
			@usr.each do |u|
				unless @users.include?( u )
					@users.push u
				end
			end
		end
	end

	def networks
		@members = current_user.networks
		
		#@members = Network.users
	end
end
