class MembershipsController < ApplicationController
  before_filter :require_user, :only => :new

  def new
		@user = current_user
		@networks = Network.all
  end

  def create
    @user_session = UserSession.new(params[:user_session])
		flash[:success] = "Login successful!"
    if @user_session.save
      redirect_back_or_default profile_url
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
