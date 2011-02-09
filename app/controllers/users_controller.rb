class UsersController < ApplicationController
  before_filter :require_not_logined
  def new
    @user = User.new
  end

  def create
    @user = User.new params[:user]
    if @user.save
      flash[:success] = "Successful Signup"
      login_as @user
      redirect_to root_url
    else
      render :new
    end
  end

end
