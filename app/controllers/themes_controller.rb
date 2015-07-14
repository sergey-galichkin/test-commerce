class ThemesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  #GET#index
  def index
  end

  #GET#new
  def new
  end

  # GET#create_completed redirect from AWS
  def create_completed
    key = params.require(:key)
    theme_file_name = key.sub(/[^_]*_/, '') # theme zip file name (theme name) is located after the first _ (underscore)
    theme_name =  File.basename theme_file_name, File.extname(theme_file_name)
    theme = Theme.create name: theme_name, zip_file_url: key, status: :processing
    if theme.valid?
      redirect_to action: :index
    else
      redirect_to action: :new
    end
  end

  #DELETE#destroy
  def destroy
  end
end
