class ThemeStatus < ActiveRecord::Base
  NAME_LIMIT = 20
  validates :name, presence: true, length: { maximum: NAME_LIMIT}, uniqueness: { case_sensitive: false }
end
