# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  describe 'schema' do
    it { is_expected.to have_db_index(:slug).unique }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    subject(:link) { build(:link) }

    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_presence_of(:slug) }

    it 'uses the UrlValidator' do
      expect(described_class.validators.map(&:class)).to include(UrlValidator)
    end

    it 'uses the SlugValidator' do
      expect(described_class.validators.map(&:class)).to include(SlugValidator)
    end
  end

  describe 'scopes' do
    let!(:link_1) { create(:link) }
    let!(:link_2) { create(:link, expires_at: nil) }
    let!(:link_3) { create(:link, expires_at: Time.zone.now) }
    let!(:link_4) { create(:link, expires_at: 1.day.ago(Time.zone.now)) }

    context 'when active' do
      it 'returns links that have no expiration or expires_at > now' do
        expect(described_class.active).to eq([link_1, link_2])
      end
    end

    context 'when expired' do
      it 'returns links that have expires_at set to <= now' do
        expect(described_class.expired).to eq([link_3, link_4])
      end
    end
  end

  describe 'factories' do
    it 'has a valid factory' do
      link = build_stubbed(:link)
      expect(link).to be_valid
    end
  end
end
