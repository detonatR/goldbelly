# frozen_string_literal: true

require 'rails_helper'

class UsesUrlValidator
  include ActiveModel::Model
  attr_accessor :site

  validates :site, url: true
end

RSpec.describe UrlValidator, type: :validator do
  subject(:uses_url_validator) { UsesUrlValidator.new(site: url) }

  context 'with a blank url' do
    let(:url) { '' }

    it { is_expected.to be_valid }
  end

  context 'when the url is valid' do
    context 'with a valid subdomain and params' do
      let(:url) { 'https://subdomain.example.com/first/second?query=param' }

      it { is_expected.to be_valid }
    end

    context 'with a valid domain' do
      let(:url) { 'http://valid_domain.com' }

      it { is_expected.to be_valid }
    end

    context 'with valid subdirectories' do
      let(:url) { 'https://valid_domain.org/first/second' }

      it { is_expected.to be_valid }
    end

    context 'with valid length' do
      let(:url) { "https://#{domain}.com" }

      context 'with length 2' do
        let(:domain) { 'a' * 2 }

        it { is_expected.to be_valid }
      end

      context 'with length 256' do
        let(:domain) { 'a' * 256 }

        it { is_expected.to be_valid }
      end
    end
  end

  context 'when the url is invalid' do
    before(:each) do
      subject.valid?
    end

    context 'with invalid length' do
      let(:url) { "https://#{domain}.com" }

      context 'with length 1' do
        let(:domain) { 'a' }

        it { expect(subject.errors.full_messages).to contain_exactly('Site is not a valid url') }
      end

      context 'with length 257' do
        let(:domain) { 'a' * 257 }

        it { expect(subject.errors.full_messages).to contain_exactly('Site is not a valid url') }
      end
    end

    context 'with invalid format' do
      let(:url) { '349058 q340958345!' }

      it { expect(subject.errors.full_messages).to contain_exactly('Site is not a parsable url') }
    end

    context 'with invalid tld' do
      let(:url) { 'https://goldbelly.$' }

      it { expect(subject.errors.full_messages).to contain_exactly('Site is not a valid url') }

      context 'with invalid domain' do
        let(:url) { 'http://subdomain.invalid&domain.$/first/second?query=params' }

        it { expect(subject.errors.full_messages).to contain_exactly('Site is not a valid url') }
      end

      context 'with missing tld' do
        let(:url) { 'https://invalid@domain/first/second' }

        it {
          expect(subject.errors.full_messages).to contain_exactly('Site is not a valid url',
                                                                  'Site please include a full domain')
        }

        context 'with missing domain' do
          let(:url) { 'http://subdomain.$/first/second' }

          it { expect(subject.errors.full_messages).to contain_exactly('Site is not a valid url') }

          context 'with missing subdomain' do
            let(:url) { 'https://?query=params' }

            it {
              expect(subject.errors.full_messages).to contain_exactly('Site host can not be blank in URLs',
                                                                      'Site is not a valid url')
            }
          end
        end
      end
    end

    context 'with invalid protocol' do
      let(:url) { 'ftp://subdomain.goldbelly.com?query=params' }

      it {
        expect(subject.errors.full_messages).to contain_exactly('Site is not a valid url',
                                                                'Site please include http or https')
      }
    end

    context 'with missing domain' do
      let(:url) { 'http://.org?query=params' }

      it { expect(subject.errors.full_messages).to contain_exactly('Site is not a valid url') }
    end
  end
end
