class ThemeStatus < ActiveRecord::Base
  NAME_LIMIT = 20
  validates_presence_of :name
  validates_length_of :name, maximum: NAME_LIMIT
  validates_uniqueness_of :name, case_sensitive: false
end
