
require "spec_helper"

RSpec.describe Api::Erp::OrdersController, :unit, type: :controller do
  render_views

  subject(:send_request) { get :show, params: params, format: :json }

  it { expect(described_class).to be < ApplicationController }

  it_behaves_like 'unauthenticated'

  context "when the user is authenticated" do
    let(:user) { create(:user) }
    before { authenticate_user(user) }

    context "when the order exists" do
      let(:order) { create(:order) }

      let(:params) { { id: order.id } }

      let(:expected_response) do
        {
          order: {
            id: order.id,
            status: order.status,
            total: OrderProduct.all.sum(&:total_price),
            createdAt: order.created_at.as_json,
            updatedAt: order.updated_at.as_json,
            products: OrderProduct.all.map do |order_product|
              {
                id: order_product.id,
                productId: order_product.product_id,
                name: order_product.product.name,
                quantity: order_product.quantity,
                price: order_product.price,
                discount: order_product.discount
              }
            end,
            customer: {
              id: order.customer.id,
              name: order.customer.name,
              email: order.customer.email,
              phone: order.customer.phone
            }
          }
        }
      end

      it { is_expected.to have_http_status(:ok) }

      it 'returns the product' do
        send_request

        expect(json_response).to match(expected_response)
      end
    end

    context "when the order does not exist" do
      let(:params) { { id: 0 } }

      it { is_expected.to have_http_status(:not_found) }

      it 'returns an error message' do
        send_request

        expect(json_response).to eq({ message: "Pedido não encontrado" })
      end
    end
  end
end
