# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:links).dependent(:destroy) }
  end

  describe 'factories' do
    it 'has a valid factory' do
      user = build_stubbed(:user)
      expect(user).to be_valid
    end
  end
end
