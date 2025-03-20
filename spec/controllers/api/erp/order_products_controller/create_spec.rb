# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::Erp::OrderProductsController, type: :controller do
  render_views

  subject(:send_request) { post :create, params: params, format: :json }

  it { expect(described_class).to be < ApplicationController }

  it_behaves_like 'unauthenticated'

  context 'when the user is authenticated' do
    context 'when is successful' do
      let(:user) { create(:user) }
      let!(:order) { create(:order) }
      let!(:product) { create(:product) }

      before { authenticate_user(user) }

      let(:params) do
        {
          order_product: {
            order_id: order.id,
            product_id: product.id,
            price: product.price,
            quantity: 1
          }
        }
      end

      let(:order_product) { OrderProduct.last }

      let(:expected_response) do
        {
          orderProduct: {
            id: order_product.id,
            name: order_product.product&.name,
            productId: order_product.product_id,
            orderId: order_product.order_id,
            price: order_product.price.to_s,
            quantity: order_product.quantity,
            discount: order_product.discount
          }
        }
      end

      it { is_expected.to have_http_status(:created) }

      it 'creates the order' do
        expect { send_request }.to change(OrderProduct, :count).by(1)
      end

      it 'returns the order product' do
        send_request

        order_product.reload

        expect(json_response).to match(expected_response)
      end
    end
  end
end
