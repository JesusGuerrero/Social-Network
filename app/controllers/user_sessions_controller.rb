class UserSessionsController < ApplicationController
	layout "user_session"
  before_filter :require_no_user, :only => [:create]
  before_filter :require_user, :only => :destroy

  def new
		if current_user_session
			redirect_to root_url
		end
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])		
    if @user_session.save
			flash[:success] = "Login successful!"
      redirect_back_or_default root_url
		elsif @user_session.attempted_record && !@user_session.invalid_password? && !@user_session.attempted_record.active?
			flash[:notice] = render_to_string(:partial => 'user_sessions/not_active.erb', :locals => { :user => @user_session.attempted_record })
			redirect_to :action => :new
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:success] = "Logout successful!"
    redirect_back_or_default signin_path
  end

end
