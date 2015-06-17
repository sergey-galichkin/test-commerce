class AccountsController < ApplicationController
  # GET /accounts
  def new
  end

  # POST /accounts
  def create
    subdomain = params[:account][:subdomain]
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
                        host: "#{subdomain}.#{request.host}",
                        token: token, email: params[:account][:email])
  end

  # GET /accounts/new/login_with_token
  def login_with_token
    render nothing: true
  end

  private

  def account_params
    params.require(:account).permit(:name, :subdomain)
  end

  def user_params
    params.require(:account).permit(:email, :password)
  end

  def subdomain_exists?(subdomain)
    if Account.exists?(subdomain: subdomain)
      render :new
      flash.alert = "Subdomain '#{subdomain}' is already registered. Try another one."
      return true
    end
    false
  end

  def create_account(subdomain, token)
    acc_params = account_params

    Account.create!(name: acc_params[:name],
                    subdomain: subdomain,
                    registration_token: token)
  end

  def create_and_switch_tenant(subdomain)
    Apartment::Tenant.create(subdomain)
    Apartment::Tenant.switch!(subdomain)
  end

  def create_user
    role = Role.find_by name: 'AccountOwner' # TODO: use permission instead of name
    usr_params = user_params
    User.create!(email: usr_params[:email], password: usr_params[:password], role_id: role.id)
  end

  def handle_error(e, subdomain)
    logger.error { "#{e.message} #{e.backtrace.join("\n")}" }
    Apartment::Tenant.drop(subdomain) rescue nil
    flash.alert = "An exception has occured during account creation.\
                     Please contact our support if the error persists."
    render :new
  end
end
