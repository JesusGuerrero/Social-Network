class Notifier < ActionMailer::Base
default_url_options[:host] = "members.linknetworker.com"

	def password_reset_instructions(user)
		subject				"Password Reset Instructions"
		from					"LinkNetworker <noreply@linknetworker.com>"
		recipients		user.email
		content_type	"text/html"
		sent_on				Time.now
		body					:edit_password_reset_url => edit_password_reset_url(user.perishable_token)
	end

	def activation_instructions(user)
		subject			"Activation Instructions"
		from				"LinkNetworker <noreply@linknetworker.com>"
		recipients	user.email
		sent_on			Time.now
		body				:account_activation_url => activate_url(user.perishable_token)
	end

	def welcome(user)
		subject			"welcome to LinkNetworker!"
		from				"LinkNetworker <noreply@linknetworker.com>"
		recipients	user.email
		sent_on			Time.now
		body				:root_url => root_url
	end
	
	def listening_event()
		subject				"Listening Event"
		from					"LinkNetworker <noreply@linknetworker.com>"
		recipients		"rjezuz@gmail.com"
		content_type	"text/html"
		sent_on				Time.now
	end

end
