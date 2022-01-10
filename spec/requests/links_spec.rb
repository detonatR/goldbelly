# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Links', type: :request do
  let(:current_user) { create(:user) }
  let(:headers) { { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' } }
  let(:token) { {} }

  let!(:links) do
    [
      create(:link, user: current_user),
      create(:link, user: current_user)
    ]
  end

  before(:each) do
    headers.merge!(token)
  end

  describe 'GET /links' do
    before(:each) { get '/links', headers: headers }

    context 'when authenticated' do
      let(:token) { current_user.create_new_auth_token }

      it { expect(response).to have_http_status 200 }
      it { expect(json_response.size).to eq 2 }
      it { expect(parsed_ids(json_response)).to eq Link.ids }
    end

    context 'when NOT authenticated' do
      it { expect(response).to have_http_status 401 }
    end
  end

  describe 'POST /links' do
    let(:url) { nil }
    let(:slug) { nil }

    let(:params) do
      {
        link: {
          url: url,
          slug: slug
        }
      }
    end

    before(:each) { post '/links', headers: headers, params: params.to_json }

    context 'when authenticated' do
      let(:link) { Link.last }
      let(:token) { current_user.create_new_auth_token }

      context 'with valid params' do
        let(:url) { 'https://google.com' }

        it { expect(response).to have_http_status 200 }

        context 'with provided slug' do
          let(:slug) { 'custom' }
          it { expect(link.slug).to eq 'custom' }
        end

        context 'without provided slug' do
          it { expect(link.slug).not_to eq 'custom' }
          it { expect(link.slug).to match SlugValidator::SLUG_REGEXP }
        end
      end

      context 'with invalid params' do
        it { expect(response).to have_http_status 422 }
        it { expect(json_response[:errors]).to eq(url: ["can't be blank"]) }
      end
    end

    context 'when NOT authenticated' do
      it { expect(response).to have_http_status 401 }
    end
  end

  describe 'PATCH /links/:id' do
    let(:url) { nil }
    let(:slug) { nil }
    let(:expires_at) { nil }

    let(:params) do
      {
        link: {
          expires_at: expires_at
        }
      }
    end

    before(:each) { put "/links/#{Link.first.id}", headers: headers, params: params.to_json }

    context 'when authenticated' do
      let(:token) { current_user.create_new_auth_token }

      context 'with valid params' do
        let(:expires_at) { 2.days.from_now(Time.zone.now) }

        it { expect(response).to have_http_status 200 }
        it { expect(Link.first.expires_at.to_i).to eq expires_at.to_i }
      end
    end

    context 'when NOT authenticated' do
      it { expect(response).to have_http_status 401 }
    end
  end

  describe 'DELETE /links/:id' do
    before(:each) { delete "/links/#{Link.first.id}", headers: headers }

    context 'when authenticated' do
      let(:token) { current_user.create_new_auth_token }

      it { expect(response).to have_http_status 204 }
      it { expect(Link.count).to eq 1 }
    end

    context 'when NOT authenticated' do
      it { expect(response).to have_http_status 401 }
    end
  end

  def parsed_ids(json_response)
    json_response.map { |record| record[:id] }
  end
end
