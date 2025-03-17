# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::Erp::CustomersController, type: :controller do
  render_views

  subject(:send_request) { put :update, params: params, format: :json }

  it { expect(described_class).to be < ApplicationController }

  it_behaves_like 'unauthenticated'

  context 'when the user is authenticated' do
    let!(:user) { create(:user) }
    let!(:customer) { create(:customer) }
    before { authenticate_user(user) }

    let(:params) do
      {
        customer: {
          name: Faker::Name.name
        },
        id: customer.id
      }
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect { send_request }.to change { customer.reload.name }.to(params[:customer][:name]) }
  end
end
