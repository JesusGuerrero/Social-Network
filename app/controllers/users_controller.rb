class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create, :resend_activation]
  before_filter :require_user, :only => [:index, :show, :edit, :update, :destroy]
  before_filter :authorized_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy
  
  def index
    @users = User.find(:all)
    @title = "All Users"
  end
  
  def new
    @user = User.new
    @title = "Sign Up"
		render :layout => "user_session"
  end
  
  def create
    @user = User.new(params[:user])
		if @user.save_without_session_maintenance
			@user.deliver_activation_instructions!
			flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
			redirect_to signin_url
    else
      @title = "Sign Up"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end
  
  def show
		if !@user = current_user
			redirect_to signin_path
		end

    @title = CGI.escapeHTML(@user.name)
  end

  def edit
    @title = "Edit Profile"
  end
  
  def update
		@user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      respond_to do |format|
        format.html {
          flash[:success] = "Settings updated!"
          redirect_to root_path
        }
        format.js {
          if params[:user][:level].nil?
            render 'progress.js.erb'
          else
            render 'complete.js.erb'
          end
        }
      end
    else
      @title = "Edit Profile"
      render 'edit'
    end
  end

	def remove_network
		@user = current_user
		@user.remove_networks( params[:id] )
		@user.save
		#flash[:success] = "Removed Network"
		redirect_to :action => "edit", :id => @user.id
	end

	def activate
		if @user = User.find_using_perishable_token(params[:activation_code], 1.week)
			if @user.activate!
				flash[:notice] = "You account has been activated!"
				UserSession.create( @user ) #Log user in manually
				@user.deliver_welcome!
				redirect_to root_url
			else
				flash[:notice] = "Our records indicate your account is active"
				render :action => :new
			end
		else
			flash[:notice] = "Activation Token Not Found! Account May Be Active!"
			redirect_to root_url
		end
	end

	def resend_activation
		if params[:id]
			@user = User.find(params[:id])
			if @user && !@user.active?
				@user.deliver_activation_instructions!
				flash[:notice] = "Please check your e-mail for your account activation instructions!"
				redirect_to signin_path
			end
		end
	end

	def add_attribute
		respond_to do |format|
			format.js
		end
	end
	  
  def destroy
    @user = User.find(params[:id])
    if current_user?(@user)
      flash[:notice] = "You cannot destroy yourself!"
    else
      @user.destroy
      flash[:success] = "User destroyed"
    end
    redirect_to users_path
  end
  
  private
    
    def authorized_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end
end
