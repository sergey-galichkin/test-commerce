class ThemesController < ApplicationController
  # GET#index
  def index
  end

  # GET#new
  def new
  end

  # GET#create_completed redirect from AWS
  def create_completed
    key = params[:key]
    theme_file_name = key.sub(/[^_]*_/, '') # theme zip file name (theme name) is located after the first _ (underscore)
    theme_name =  File.basename theme_file_name, File.extname(theme_file_name)
    return redirect_to action: :new unless theme_name.present? && File.extname(theme_file_name).downcase.eql?('.zip')

    Theme.create! name: theme_name, zip_file_url: key, status: :processing
    redirect_to action: :index
  end
end
