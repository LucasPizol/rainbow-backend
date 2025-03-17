
require "spec_helper"

RSpec.describe Api::Erp::OrderProductsController, :unit, type: :controller do
  render_views

  subject(:send_request) { put :update, params: params, format: :json }

  it { expect(described_class).to be < ApplicationController }

  it_behaves_like 'unauthenticated'

  context "when the user is authenticated" do
    let(:user) { create(:user) }
    before { authenticate_user(user) }

    context "when the order product exists" do
      let!(:order_product) { create(:order_product, quantity: 1) }

      let(:params) { { id: order_product.id, order_product: { quantity: 2 } } }

      let(:expected_response) do
        {
          orderProduct: {
            id: order_product.id,
            name: order_product.product.name,
            productId: order_product.product_id,
            orderId: order_product.order_id,
            price: order_product.price,
            quantity: 2,
            discount: order_product.discount
          }
        }
      end

      it { is_expected.to have_http_status(:ok) }

      it 'returns the order product' do
        send_request

        order_product.reload

        expect(json_response).to match(expected_response)
      end
    end

    context "when the order product does not exist" do
      let(:params) { { id: 0 } }

      it { is_expected.to have_http_status(:not_found) }

      it 'returns an error message' do
        send_request

        expect(json_response).to eq({ message: "Produto do pedido não encontrado" })
      end
    end
  end
end
