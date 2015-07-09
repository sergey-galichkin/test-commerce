class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

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
    @user = User.new user_params
    if @user.save
      redirect_to users_path
    else
      render :new
    end
  end

  # GET#edit
  def edit
  end

  # PUT/PATCH#update
  def update
    if @user.update user_params
      sign_in(@user, bypass: true) if user_params[:password].present? && @user == current_user
      redirect_to users_path
    else
      render :edit
    end
  end

  # DELETE#destroy
  def destroy
    @user.destroy unless @user == current_user
    redirect_to users_path
  end

  private

  def user_params
    params.required(:user).permit case params[:action]
    when 'update'
      par = []
      par << :role_id if can? :update_users_role, User
      par << :password if can? :update_users_password, User
      par
    when 'create'
      [:password, :role_id, :email]
    else
      []
    end
  end
end
