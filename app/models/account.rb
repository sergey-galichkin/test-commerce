class Account < ActiveRecord::Base
  validates_presence_of :name, :subdomain
  validates_uniqueness_of :subdomain, case_sensitive: false

  before_create { Apartment::Tenant.create subdomain }
  before_destroy { Apartment::Tenant.drop subdomain }
end
