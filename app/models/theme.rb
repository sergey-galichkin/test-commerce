class Theme < ActiveRecord::Base
  NAME_LIMIT = 100
  ZIP_FILE_URL_LIMIT = 2000

  validates_presence_of :name, :zip_file_url, :theme_status
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :zip_file_url, maximum: ZIP_FILE_URL_LIMIT
  validates_uniqueness_of :name, :zip_file_url, case_sensitive: false

  belongs_to :theme_status
end