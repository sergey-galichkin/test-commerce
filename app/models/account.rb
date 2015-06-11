class Account < ActiveRecord::Base
  validates :name, :subdomain, presence: true
end
