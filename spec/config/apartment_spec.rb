require 'rails_helper'

RSpec.describe Apartment do
  describe "excluded models" do
    subject { Apartment.excluded_models }
    it { is_expected.to match_array %w{ Account Role } }
  end
end
