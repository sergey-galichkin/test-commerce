class UsersController < ApplicationController
  before_action :authenticate_user!

  # GET#index
  def index
  end

  # GET#new
  def new
  end

  # POST#create
  def create
    user= User.new user_params
    if user.save
      redirect_to users_path
    else
      render :new
    end
  end

  private

  def user_params
    params.required(:user).permit(:email, :role_id, :password)
  end
end
