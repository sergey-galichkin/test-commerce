class AccountsController < ApplicationController
  # GET /accounts
  def new
  end

  # POST /accounts
  def create
    account = Account.new account_params
    account.registration_token = SecureRandom.uuid
    p account.valid?
    return render :new until account.save
    p "4"

    begin
      Apartment::Tenant.switch!(account.subdomain)

      user = User.new user_params
      role_params = { can_create_users: true, can_update_users_password: true, can_update_users_role: true, can_delete_users: true }
      user.role = Role.find_by(role_params) || Role.create!(role_params.merge({ name:'AccountOwner'}))
      user.save!

      redirect_to url_for(action: :login_with_token, subdomain: account.subdomain, token: account.registration_token, email: user.email)
    rescue
      account.destroy
      Apartment::Tenant.reset
      render :new
    end
  end

  # GET /accounts/new/login_with_token
  def login_with_token
    return handle_wrong_login_params unless params.key?(:email) && params.key?(:token)

    account = Account.find_by_registration_token_and_subdomain params[:token], Apartment::Tenant.current
    user = User.find_by_email params[:email]
    return handle_wrong_login_params unless account && user

    account.update registration_token: nil
    sign_in user, bypass: true

    render :account_created
  end

  private

  def account_params
    params.require(:account).permit(:name, :subdomain)
  end

  def user_params
    params.require(:account).permit(:email, :password)
  end

  def handle_wrong_login_params
    Apartment::Tenant.reset
    redirect_to url_for(action: :new, subdomain: false)
  end
end
