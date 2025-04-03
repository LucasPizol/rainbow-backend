# frozen_string_literal: true

require "spec_helper"

RSpec.describe Api::Erp::ProductsController, :unit, type: :controller do
  render_views

  subject(:send_request) { post :create, params: params, format: :json }

  it { expect(described_class).to be < ApplicationController }

  it_behaves_like 'unauthenticated'

  context "when the user is authenticated" do
    let(:user) { create(:user) }
    before { authenticate_user(user) }

    context "when is successful" do
      let!(:category) { create(:category) }
      let!(:subcategory) { create(:subcategory) }

      let(:params) do
        {
          product: {
            name: Faker::Name.name,
            price: 100,
            description: Faker::Lorem.paragraph,
            category_id: category.id,
            cost_price: 50,
            stock: 0,
            minimum_stock: 1
          }
        }
      end

      let(:product) { Product.last }

      let(:expected_response) do
        {
          product: {
            id: product.id,
            name: product.name,
            price: '100.0',
            costPrice: '50.0',
            description: product.description,
            minimumStock: 1,
            images: [],
            stock: 0,
            category: {
              id: category.id,
              name: category.name
            },
            subcategories: []
          }
        }
      end


      it { is_expected.to have_http_status(:created) }

      it 'creates the product' do
        send_request

        product.reload

        expect(json_response).to match(expected_response)
      end
    end
  end
end
