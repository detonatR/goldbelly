# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Redirects', type: :request do
  let!(:link) { create(:link, expires_at: expires_at) }
  let(:slug) { link.slug }
  let(:expires_at) { nil }

  describe 'GET /s/:slug' do
    before { get "/s/#{slug}" }

    context 'when active' do
      it { expect(response).to redirect_to link.url }
      it { expect(response).to have_http_status(301) }
    end

    context 'when expired' do
      let(:expires_at) { 2.days.ago(Time.zone.now) }

      it { expect(response).to have_http_status(404) }
    end

    context 'when not found' do
      let(:slug) { 'example' }

      it { expect(response).to have_http_status(404) }
    end
  end
end
