class ThemesController < ApplicationController
  def index
  end

  def new
  end

  #redirect from AWS
  def create_completed
    key = params[:key]
    theme_name = key.sub /[^_]*_/, "" #theme zip file name (theme name) is located after the first _ (underscore)
    theme_status = ThemeStatus.find_by_name! :Processing
    Theme.create! name: theme_name, zip_file_url: key, theme_status: theme_status
    redirect_to action: :index
  end
end
