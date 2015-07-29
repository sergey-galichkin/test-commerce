class Theme < ActiveRecord::Base
  after_validation :schedule_theme_delete, on: :create, if: "errors.present?"
  before_destroy :schedule_theme_delete
  after_create :schedule_theme_transfer

  NAME_LIMIT = 100
  ZIP_FILE_URL_LIMIT = 2000

  enum status: { processing: 0, uploaded: 1 }

  validates :name, presence: true, length: { maximum: NAME_LIMIT }, uniqueness: { case_sensitive: false }
  validates :zip_file_url, presence: true, format: { with: /\.(zip)\z/i }, length: { maximum: ZIP_FILE_URL_LIMIT }, uniqueness: { case_sensitive: false }
  validates :status, presence: true

  private

  def schedule_theme_transfer
    TransferThemeJob.perform_later(self)
  end

  def schedule_theme_delete
    DeleteThemeJob.perform_later(zip_file_url, processing?)
  end
end
