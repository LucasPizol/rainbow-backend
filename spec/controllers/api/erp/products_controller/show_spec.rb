
require "spec_helper"

RSpec.describe Api::Erp::ProductsController, :unit, type: :controller do
  render_views

  subject(:send_request) { get :show, params: params, format: :json }

  it { expect(described_class).to be < ApplicationController }

  it_behaves_like 'unauthenticated'

  context "when the user is authenticated" do
    let(:user) { create(:user) }
    before { authenticate_user(user) }

    context "when the product exists" do
      let!(:product) { create(:product) }

      let(:params) { { id: product.id } }

      let(:expected_response) do
        {
          product: {
            id: product.id,
            name: product.name,
            price: product.price.to_s,
            costPrice: product.cost_price.to_s,
            images: [],
            description: product.description,
            minimumStock: product.minimum_stock,
            stock: product.stock,
            category: {
              id: product.category.id,
              name: product.category.name
            },
            subcategories: product.subcategories.map do |subcategory|
              {
                id: subcategory.id,
                name: subcategory.name
              }
            end
          }
        }
      end

      it { is_expected.to have_http_status(:ok) }

      it 'returns the product' do
        send_request

        expect(json_response).to match(expected_response)
      end
    end

    context "when the product does not exist" do
      let(:params) { { id: 0 } }

      it { is_expected.to have_http_status(:not_found) }

      it 'returns an error message' do
        send_request

        expect(json_response).to eq({ message: "Produto não encontrado" })
      end
    end
  end
end
