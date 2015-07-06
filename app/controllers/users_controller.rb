class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update, :destroy]

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
      sign_in(current_user, bypass: true) if user_params[:password].present? && @user == current_user
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

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.required(:user).permit case params[:action]
    when 'update'
      par = Array.new
      if @user == current_user && current_user.role.name != 'AccountOwner'
        par << :password
      else
        par << (params[:user][:password].present? && :password)
      end
      par << (params[:user][:role_id].present? && :role_id)
    when 'create'
      [:password, :role_id, :email]
    else
      []
    end
  end
end
