class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path,  alert: exception.message
  end

  protected

  # Helper method used in layout to render model errors, should be overriden in controllers
  def errors
    {}
  end
  helper_method :errors

end
