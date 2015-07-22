class ThemesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET#index
  def index
    @themes = Theme.all
  end

  # GET#create_completed redirect from AWS
  def create_completed
    key = params.require(:key)
    theme_file_name = key.sub(/[^_]*_/, '') # theme zip file name (theme name) is located after the first _ (underscore)
    theme_name =  File.basename theme_file_name, File.extname(theme_file_name)
    theme = Theme.new name: theme_name, zip_file_url: key, status: :processing
    redirect_to action: (theme.save ? 'index' : 'new')
  end

  # DELETE#destroy
  def destroy
    @theme.destroy
    redirect_to themes_path
  end
end
