# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Session', type: :request do
  let(:user) { create(:user) }
  let(:signin_url) { '/auth/sign_in' }
  let(:signout_url) { '/auth/sign_out' }

  let(:login_params) do
    {
      email: user.email,
      password: user.password
    }
  end

  describe 'POST /auth/sign_in' do
    context 'when login params is valid' do
      before { post signin_url, params: login_params, as: :json }

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns access-token in authentication header' do
        expect(response.headers['access-token']).to be_present
      end

      it 'returns client in authentication header' do
        expect(response.headers['client']).to be_present
      end

      it 'returns expiry in authentication header' do
        expect(response.headers['expiry']).to be_present
      end

      it 'returns uid in authentication header' do
        expect(response.headers['uid']).to be_present
      end
    end

    context 'when login params is invalid' do
      before { post signin_url }

      it 'returns unathorized status 401' do
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE /auth/sign_out' do
    let(:headers) do
      {
        'uid' => response.headers['uid'],
        'client' => response.headers['client'],
        'access-token' => response.headers['access-token']
      }
    end

    before { post signin_url, params: login_params, as: :json }

    it 'returns status 200' do
      delete signout_url, headers: headers
      expect(response).to have_http_status(200)
    end
  end
end
