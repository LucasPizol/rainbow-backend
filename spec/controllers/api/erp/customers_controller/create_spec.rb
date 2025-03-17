# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::Erp::CustomersController, type: :controller do
  render_views

  subject(:send_request) { post :create, params: params, format: :json }

  it { expect(described_class).to be < ApplicationController }

  it_behaves_like 'unauthenticated'

  context 'when the user is authenticated' do
    context 'when is successful' do
      let!(:user) { create(:user) }
      before { authenticate_user(user) }

      let(:params) do
        {
          customer: {
            name: Faker::Name.name,
            email: Faker::Internet.email,
            phone: Faker::PhoneNumber.phone_number,
            address: Faker::Address.full_address
          }
        }
      end

      let(:customer) { Customer.last }

      let(:expected_response) do
        {
          customer: {
            id: customer.id,
            name: params[:customer][:name],
            email: params[:customer][:email],
            phone: params[:customer][:phone],
            address: params[:customer][:address],
            createdAt: customer.created_at.as_json,
            updatedAt: customer.updated_at.as_json,
            products: [],
            orders: []
          }
        }
      end

      it { is_expected.to have_http_status(:created) }

      it 'creates the customer' do
        expect { send_request }.to change(Customer, :count).by(1)
      end

      it 'returns the customer' do
        send_request

        customer.reload

        expect(json_response).to match(expected_response)
      end
    end
  end
end
