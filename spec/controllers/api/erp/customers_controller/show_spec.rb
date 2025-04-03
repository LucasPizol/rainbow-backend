
require "spec_helper"

RSpec.describe Api::Erp::CustomersController, :unit, type: :controller do
  render_views

  subject(:send_request) { get :show, params: params, format: :json }

  it { expect(described_class).to be < ApplicationController }

  it_behaves_like 'unauthenticated'

  context "when the user is authenticated" do
    let(:user) { create(:user) }
    before { authenticate_user(user) }

    context "when the customer exists" do
      let!(:customer) { create(:customer) }

      before do
        product = create(:product)
        create_list(:order, 3, customer: customer)
        create_list(:order_product, 3, order: Order.first, product: product)
      end

      let(:params) { { id: customer.id } }

      let(:expected_response) do
        {
          customer: {
            id: customer.id,
            name: customer.name,
            email: customer.email,
            phone: customer.phone,
            address: customer.address,
            createdAt: customer.created_at.as_json,
            updatedAt: customer.updated_at.as_json,
            products: OrderProduct.all.map do |order_product|
              {
                id: order_product.id,
                orderId: order_product.order_id,
                price: order_product.price.to_s,
                quantity: order_product.quantity,
                discount: order_product.discount.to_s,
                product: {
                  id: order_product.product_id,
                  name: order_product.product&.name,
                  price: order_product.product&.price.to_s
                }
              }
            end,
            orders: Order.all.map do |order|
              {
                id: order.id,
                status: order.status,
                total: order.total.to_s,
                createdAt: order.created_at.as_json,
                updatedAt: order.updated_at.as_json
              }
            end
          }
        }
      end

      it { is_expected.to have_http_status(:ok) }

      it 'returns the customer' do
        send_request

        expect(json_response).to match(expected_response)
      end
    end

    context "when the customer does not exist" do
      let(:params) { { id: 0 } }

      it { is_expected.to have_http_status(:not_found) }

      it 'returns an error message' do
        send_request

        expect(json_response).to eq({ message: "Cliente não encontrado" })
      end
    end
  end
end
