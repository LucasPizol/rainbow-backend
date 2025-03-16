# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::Erp::LoginController, :unit, type: :controller do
  render_views

  subject(:send_request) { post :create, params: params, format: :json }

  it { expect(described_class).to be < ApplicationController }

  describe 'POST #create' do
    context 'when the user exists' do
      let!(:user) { create(:user) }
      let(:params) { { user: { email: user.email, password: user.password } } }

      it { is_expected.to have_http_status(:ok) }

      it 'returns a token' do
        send_request

        expect(JSON.parse(response.body, symbolize_names: true)).to include(:token)
      end
    end

    context 'when the user does not exist' do
      it 'returns an error' do
        post :create, params: { user: { email: 'nonexistent@example.com', password: 'nonexistent' } }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['message']).to eq('Usuário ou senha inválidos')
      end
    end
  end
end
