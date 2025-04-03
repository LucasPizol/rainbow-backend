# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::Erp::ProductsController, :unit, type: :controller do
  render_views

  subject(:send_request) { get :index, format: :json }

  it { expect(described_class).to be < ApplicationController }

  it_behaves_like 'unauthenticated'

  context "when the user is authenticated" do
    let!(:user) { create(:user) }

    before do
      authenticate_user(user)
      create_list(:product, 3)
    end

    context "when the products are returned" do
      it { is_expected.to have_http_status(:ok) }

      let(:expected_response) do
        {
          data: Product.all.includes(:category, :subcategories).order(name: :asc).map do |product|
            {
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
          end,
          page: 1,
          pages: 1,
          total: 3
        }
      end

      it 'returns the products' do
        send_request

        expect(json_response).to match(expected_response)
      end
    end
  end
end
