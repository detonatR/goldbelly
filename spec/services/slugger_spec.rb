# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Slugger, type: :service do
  let(:user) { create(:user) }
  let(:url) { 'https://google.com' }
  let(:custom_slug) { nil }
  let(:expires_at) { nil }

  let(:options) do
    {
      user: user,
      url: url,
      custom_slug: custom_slug,
      expires_at: expires_at
    }
  end

  describe '.generate' do
    subject(:class_generate) { Slugger.generate(**options) }
    let(:slugger) { instance_double(Slugger) }

    it 'initializes and calls generate instance method' do
      expect(Slugger).to receive(:new).with(options).and_return(slugger)
      expect(slugger).to receive(:generate)

      subject
    end
  end

  describe '#generate' do
    subject(:slugger) { Slugger.new(**options).generate }

    it 'sets the correct user' do
      expect(subject.user).to eq user
    end

    context 'url' do
      let(:url) { 'HttP ://gOogle .com ' }

      it 'strips whitespaces and downcases' do
        expect(subject.url).to eq 'http://google.com'
      end
    end

    context 'expires_at' do
      let(:expires_at) { 2.days.from_now(Time.zone.now) }

      it 'sets the provided expires_at' do
        expect(subject.expires_at).to eq expires_at
      end
    end

    context 'slug' do
      context 'with custom slug' do
        let(:custom_slug) { 'customslug' }

        it 'returns the custom slug' do
          expect(subject.slug).to eq custom_slug
        end
      end

      context 'without custom slug' do
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
  end
end
