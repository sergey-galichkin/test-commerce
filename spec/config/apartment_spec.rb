require 'rails_helper'

RSpec.describe Apartment.excluded_models do
  describe "Apartment.excluded_models" do
    it { is_expected.to match_array %w{ Account Role } }
  end
end
