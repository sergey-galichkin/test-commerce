class Theme < ActiveRecord::Base
  NAME_LIMIT = 100
  ZIP_FILE_URL_LIMIT = 2000

  enum status: { processing: 0 }

  validates :name, presence: true, length: { maximum: NAME_LIMIT }, uniqueness: { case_sensitive: false }
  validates :zip_file_url, presence: true, format: {with: /\.(zip)\z/i }, length: { maximum: ZIP_FILE_URL_LIMIT }, uniqueness: { case_sensitive: false }
  validates :status, presence: true
end