class UsersController < ApplicationController
  before_filter :save_login_state, :only => [:new, :create]
  
  def new
    #Signup form
    @user = User.new
  end
  def create
    #Create a new user
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Yay, your registration was successful"
      flash[:color] = "valid"
    else
      flash[:notice] = "Darn, something went wrong!"
      flash[:color] = "invalid"
    end
    render "new"
  end
  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
