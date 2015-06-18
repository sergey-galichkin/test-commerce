class AccountsController < ApplicationController
  # GET /accounts
  def new
  end

  # POST /accounts
  def create
    subdomain = account_params[:subdomain]
    return if subdomain_exists? subdomain

    token = SecureRandom.uuid

    begin
      Account.transaction do
        create_account(subdomain, token)

        create_and_switch_tenant(subdomain)

        create_user
      end
    rescue => e
      return handle_error(e, subdomain)
    end

    redirect_to url_for(action: :login_with_token,
                        subdomain: subdomain,
                        token: token, email: user_params[:email])
  end

  # GET /accounts/new/login_with_token
  def login_with_token
    return unless login_params_present?
    return if login_params_wrong?

    account = Account.find_by(registration_token: params.require(:token), subdomain: Apartment::Tenant.current)
    account.update(registration_token: nil)

    user = User.find_by(email: params.require(:email))
    sign_in user, bypass: true

    redirect_to :root
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
    if Account.exists?(subdomain: subdomain)
      render :new
      return true
    end
    false
  end

  def create_account(subdomain, token)
    Account.create!(name: account_params[:name],
                    subdomain: subdomain,
                    registration_token: token)
  end

  def create_and_switch_tenant(subdomain)
    Apartment::Tenant.create(subdomain)
    Apartment::Tenant.switch!(subdomain)
  end

  def create_user
    role = Role.find_by name: 'AccountOwner' # TODO: use permission instead of name
    User.create!(email: user_params[:email], password: user_params[:password], role_id: role.id)
  end

  def handle_error(e, subdomain)
    logger.error { "#{e.message} #{e.backtrace.join("\n")}" }
    Apartment::Tenant.drop(subdomain) rescue nil
    render :new
  end

  def login_params_present?
    return true if params.key?(:email) && params.key?(:token)

    handle_wrong_login_params

    false
  end

  def login_params_wrong?
    unless User.exists?(email: params.required(:email)) && Account.exists?(registration_token: params.required(:token))
      handle_wrong_login_params
      true
    end
  end

  def handle_wrong_login_params
    Apartment::Tenant.reset
    redirect_to url_for(action: :new, subdomain: false)
  end
end
