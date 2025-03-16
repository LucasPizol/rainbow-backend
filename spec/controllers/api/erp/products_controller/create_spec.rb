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
            subcategory_id: subcategory.id,
            stock: 0
          }
        }
      end

      let(:product) { Product.last }

      let(:expected_response) do
        {
          product: {
            id: product.id,
            name: product.name,
            price: 100,
            description: product.description,
            category: {
              id: category.id,
              name: category.name
            },
            subcategory: {
              id: subcategory.id,
              name: subcategory.name
            },
            stock: 0
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

    context "when creating an category" do
      let!(:subcategory) { create(:subcategory) }

      let(:params) do
        {
          product: {
            name: Faker::Name.name,
            price: 100,
            description: Faker::Lorem.paragraph,
            subcategory_id: subcategory.id,
            stock: 0
          },
          category: {
            name: Faker::Name.name
          }
        }
      end

      let(:category) { Category.last }
      let(:product) { Product.last }

      let(:expected_response) do
        {
          product: {
            id: product.id,
            name: product.name,
            price: 100,
            description: product.description,
            category: {
              id: category.id,
              name: category.name
            },
            subcategory: {
              id: subcategory.id,
              name: subcategory.name
            },
            stock: 0
          }
        }
      end

      it { is_expected.to have_http_status(:created) }
      it { expect { send_request }.to change { Category.count }.by(1) }

      it 'creates the product' do
        send_request

        product.reload
        category.reload

        expect(json_response).to match(expected_response)
      end
    end

    context "when creating an subcategory" do
      let!(:category) { create(:category) }

      let(:params) do
        {
          product: {
            name: Faker::Name.name,
            price: 100,
            description: Faker::Lorem.paragraph,
            category_id: category.id,
            stock: 0
          },
          subcategory: {
            name: Faker::Name.name
          }
        }
      end

      let(:subcategory) { Subcategory.last }
      let(:product) { Product.last }

      let(:expected_response) do
        {
          product: {
            id: product.id,
            name: product.name,
            price: 100,
            description: product.description,
            category: {
              id: category.id,
              name: category.name
            },
            subcategory: {
              id: subcategory.id,
              name: subcategory.name
            },
            stock: 0
          }
        }
      end

      it { is_expected.to have_http_status(:created) }
      it { expect { send_request }.to change { Subcategory.count }.by(1) }

      it 'creates the product' do
        send_request

        product.reload
        subcategory.reload

        expect(json_response).to match(expected_response)
      end
    end
  end
end
