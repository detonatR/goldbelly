# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SlugValidator, type: :validator do
  subject(:uses_slug_validator) { build(:link, slug: slug) }

  describe 'uniqueness' do
    let(:slug) { 'customslug' }

    context 'when persisted' do
      subject(:uses_slug_validator) { create(:link) }

      context 'when there is an existing record' do
        let!(:link) { create(:link, slug: slug) }

        it 'is invalid' do
          subject.slug = slug
          subject.valid?
          expect(subject.errors.full_messages).to contain_exactly('Slug has already been taken')
        end
      end

      context 'when there is NO existing record' do
        it 'is valid' do
          subject.slug = slug
          expect(subject).to be_valid
        end
      end
    end

    context 'when NOT persisted' do
      context 'when there is an existing record' do
        let!(:link) { create(:link, slug: slug) }

        it 'is invalid' do
          subject.valid?
          expect(subject.errors.full_messages).to contain_exactly('Slug has already been taken')
        end
      end

      context 'when there is NO existing record' do
        it { is_expected.to be_valid }
      end
    end
  end

  describe 'format' do
    describe 'alphanumeric' do
      context 'with letters' do
        context 'with numbers' do
          %w[
            12312
            abcde
            1abc2
            abc123
            123abc
            a123b
          ].each do |value|
            let(:slug) { value }

            it { expect(subject).to be_valid }
          end
        end
      end
    end

    describe 'non alphanumeric' do
      let(:slug) { '!@,?:-$=+' }

      it 'is invalid' do
        subject.valid?
        expect(subject.errors.full_messages).to contain_exactly('Slug is invalid')
      end
    end
  end
end
