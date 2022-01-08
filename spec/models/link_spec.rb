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

    it { is_expected.to validate_uniqueness_of(:url) }
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

  describe '#slug' do
    subject(:link) { create(:link, slug: slug) }

    context 'when there is a slug set' do
      let(:slug) { 'custom' }

      it 'returns the existing slug' do
        expect(subject.slug).to eq slug
      end
    end

    context 'when there is NO slug set' do
      let(:slug) { nil }
      let(:uuid) { 'abc123' }

      before(:each) do
        allow(SecureRandom).to receive(:uuid).and_return(uuid, SecureRandom.uuid[0..5])
      end

      context 'when there is an existing record' do
        let!(:record) { create(:link, slug: uuid) }

        it 'generates a new uuid' do
          expect(subject.slug).not_to eq uuid
        end
      end

      context 'when there is NO existing record' do
        it 'returns the first uuid' do
          expect(subject.slug).to eq uuid
        end
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
