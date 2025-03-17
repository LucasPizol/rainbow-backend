# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::Erp::OrdersController, :unit, type: :controller do
  render_views

  subject(:send_request) { get :index, format: :json }

  it { expect(described_class).to be < ApplicationController }

  it_behaves_like 'unauthenticated'

  context "when the user is authenticated" do
    let!(:user) { create(:user) }

    before do
      authenticate_user(user)
      create_list(:order, 3)
    end

    context "when the orders are returned" do
      it { is_expected.to have_http_status(:ok) }

      let(:expected_response) do
        {
          data: Order.all.map do |order|
            {
              id: order.id,
              status: order.status,
              total: OrderProduct.all.sum(&:total_price),
              createdAt: order.created_at.as_json,
              updatedAt: order.updated_at.as_json,
              customer: {
                id: order.customer.id,
                name: order.customer.name,
                email: order.customer.email,
                phone: order.customer.phone
              }
            }
          end,
          page: 1,
          pages: 1,
          total: 3
        }
      end

      it 'returns the orders' do
        send_request

        expect(json_response).to match(expected_response)
      end
    end
  end
end
