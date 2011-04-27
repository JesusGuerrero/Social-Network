class MembershipsController < ApplicationController
  before_filter :require_user, :only => :new

  def new
		@user = current_user
		@networks = Network.all
		@membership = Membership.new( :user_id => @user.id )
  end

  def create
		@membership = Membership.new( params[:membership] )
		@membership.save
		redirect_to root_url
  end

  def destroy
  end

end
