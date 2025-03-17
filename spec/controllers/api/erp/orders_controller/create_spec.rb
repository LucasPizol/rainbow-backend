# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::Erp::OrdersController, type: :controller do
  render_views

  subject(:send_request) { post :create, params: params, format: :json }

  it { expect(described_class).to be < ApplicationController }

  it_behaves_like 'unauthenticated'

  context 'when the user is authenticated' do
    context 'when is successful' do
      let(:user) { create(:user) }
      let!(:customer) { create(:customer) }
      before { authenticate_user(user) }

      let(:params) do
        {
          order: {
            customer_id: customer.id,
            total: 100,
            status: 'pending'
          }
        }
      end

      let(:order) { Order.last }

      let(:expected_response) do
        {
          order: {
            id: order.id,
            status: 'pending',
            total: 0,
            createdAt: order.created_at.as_json,
            updatedAt: order.updated_at.as_json,
            customer: {
              id: customer.id,
              name: customer.name,
              email: customer.email,
              phone: customer.phone
            }
          }
        }
      end

      it { is_expected.to have_http_status(:created) }

      it 'creates the order' do
        expect { send_request }.to change(Order, :count).by(1)
      end

      it 'returns the order' do
        send_request

        order.reload

        expect(json_response).to match(expected_response)
      end
    end

    context 'when sending with nested attributes' do
      let(:user) { create(:user) }
      let!(:customer) { create(:customer) }
      let!(:product_1) { create(:product) }
      let!(:product_2) { create(:product) }
      before { authenticate_user(user) }

      let(:params) do
        {
          order: {
            customer_id: customer.id,
            status: 'pending',
            order_products_attributes: [
              {
                product_id: product_1.id,
                quantity: 1,
                price: product_1.price
              },
              {
                product_id: product_2.id,
                quantity: 2,
                price: product_2.price
              }
            ]
          }
        }
      end

      let(:order) { Order.last }

      let(:expected_response) do
        {
          order: {
            id: order.id,
            status: 'pending',
            total: OrderProduct.all.sum(&:total_price),
            createdAt: order.created_at.as_json,
            updatedAt: order.updated_at.as_json,
            customer: {
              id: customer.id,
              name: customer.name,
              email: customer.email,
              phone: customer.phone
            }
          }
        }
      end

      it { is_expected.to have_http_status(:created) }

      it 'creates the order' do
        expect { send_request }.to change(Order, :count).by(1)
      end

      it 'returns the order' do
        send_request

        order.reload

        expect(json_response).to match(expected_response)
      end
    end
  end
end
