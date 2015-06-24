class AccountsController < ApplicationController
  # GET /accounts
  def new
  end

  # POST /accounts
  def create
    subdomain = account_params[:subdomain]
    return render :new if subdomain_exists? subdomain

    token = SecureRandom.uuid

    role = Role.find_by name: 'AccountOwner'
    account = Account.new account_params
    account.registration_token = token
    begin
      if account.save
        Apartment::Tenant.switch!(subdomain)
        user = User.create(email: user_params[:email], password: user_params[:password], role_id: role.id)
        if user.persisted?
          redirect_to url_for(action: :login_with_token, subdomain: subdomain, token: token, email: user_params[:email])
        else
          account.destroy
          Apartment::Tenant.reset
          render :new
        end
      else
        render :new
      end
    rescue => e
      account.destroy
      Apartment::Tenant.reset
      render :new
    end
  end

  # GET /accounts/new/login_with_token
  def login_with_token
    return handle_wrong_login_params unless login_params_present?
    return handle_wrong_login_params unless login_params_valid?

    account = Account.find_by(registration_token: params.require(:token), subdomain: Apartment::Tenant.current)
    account.update(registration_token: nil)

    user = User.find_by(email: params.require(:email))
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

  def login_with_token_params
    params.permit(:email, :token)
  end

  def subdomain_exists?(subdomain)
    Account.exists?(subdomain: subdomain)
  end

  def login_params_present?
    params.key?(:email) && params.key?(:token)
  end

  def login_params_valid?
    User.exists?(email: params.required(:email)) && Account.exists?(registration_token: params.required(:token))
  end

  def handle_wrong_login_params
    Apartment::Tenant.reset
    redirect_to url_for(action: :new, subdomain: false)
  end
end
