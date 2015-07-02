class UsersController < ApplicationController
  before_action :authenticate_user!

  # GET#index
  def index
    @users = User.all
  end

  # GET#new
  def new
    @user = User.new
  end

  # POST#create
  def create
    user = User.new create_params
    if user.save
      redirect_to users_path
    else
      render :new
    end
  end

  # GET#edit
  def edit
    @user = User.find params[:id]
  end

  # PUT/PATCH#update
  def update
    user = User.find params[:id]
    params[:user].delete(:password) if params[:user][:password].blank?
    if user.update(update_params)
      redirect_to users_path
    else
      render :edit
    end
  end

  # DELETE#destroy
  def destroy
    User.find(params[:id]).destroy unless params[:id].to_i == current_user.id
    redirect_to users_path
  end

  # GET#edit_password
  def edit_password
  end

  # PATCH#update_password
  def update_password
    return render :edit_password if params[:user].blank?

    if current_user.update update_password_params
      sign_in current_user, :bypass => true
      redirect_to root_path
    else
      render :edit_password
    end
  end

  private

  def create_params
    params.required(:user).permit(:email, :role_id, :password)
  end

  def update_params
    params.required(:user).permit(:role_id, :password)
  end

  def update_password_params
    params.required(:user).permit(:password)
  end
end
