class Role < ActiveRecord::Base
  NAME_LIMIT_MAX = 50
  validates :name, presence: true, uniqueness: true, length: { maximum: NAME_LIMIT_MAX }
end
