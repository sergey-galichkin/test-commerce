class ThemesController < ApplicationController
  def index
  end

  def new
  end

  #redirect from AWS
  def create_completed
    key = params[:key]
    theme_name = key.sub /[^_]*_/, "" #theme zip file name (theme name) is located after the first _ (underscore)
    Theme.create! name: theme_name, zip_file_url: key, status: :processing
    redirect_to action: :index
  end
end
