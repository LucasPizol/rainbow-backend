# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::Erp::CustomersController, :unit, type: :controller do
  render_views

  subject(:send_request) { get :index, format: :json }

  it { expect(described_class).to be < ApplicationController }

  it_behaves_like 'unauthenticated'

  context "when the user is authenticated" do
    let!(:user) { create(:user) }

    before do
      authenticate_user(user)
      create_list(:customer, 3)
    end

    context "when the customers are returned" do
      it { is_expected.to have_http_status(:ok) }

      let(:expected_response) do
        {
          data: Customer.all.map do |customer|
            {
              id: customer.id,
              name: customer.name,
              email: customer.email,
              phone: customer.phone,
              address: customer.address,
              createdAt: customer.created_at.as_json,
              updatedAt: customer.updated_at.as_json
            }
          end,
          page: 1,
          pages: 1,
          total: 3
        }
      end

      it 'returns the customers' do
        send_request

        expect(json_response).to match(expected_response)
      end
    end
  end
end
