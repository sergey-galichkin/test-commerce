class Account < ActiveRecord::Base
  validates_presence_of :name, :subdomain
  validates_uniqueness_of :subdomain, case_sensitive: false
end
