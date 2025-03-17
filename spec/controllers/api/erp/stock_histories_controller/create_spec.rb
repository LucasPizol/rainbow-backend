# frozen_string_literal: true

require "spec_helper"

RSpec.describe Api::Erp::StockHistoriesController, :unit, type: :controller do
  render_views

  subject(:send_request) { post :create, params: params, format: :json }

  it { expect(described_class).to be < ApplicationController }

  it_behaves_like 'unauthenticated'

  context "when the user is authenticated" do
    let(:user) { create(:user) }
    before { authenticate_user(user) }

    context "when is successful" do
      let!(:product) { create(:product) }

      let(:params) do
        {
          stock_history: {
            product_id: product.id,
            quantity: 1,
            price: 100.0,
            operation: 'entry',
            description: Faker::Lorem.paragraph
          }
        }
      end

      let(:stock_history) { StockHistory.last }

      let(:expected_response) do
        {
          stockHistory: {
            id: stock_history.id,
            quantity: stock_history.quantity,
            price: stock_history.price.to_s,
            operation: stock_history.operation,
            createdAt: stock_history.created_at.as_json,
            product: {
              id: stock_history.product.id,
              name: stock_history.product.name
            }
          }
        }
      end

      it { is_expected.to have_http_status(:created) }

      it 'creates the stock history' do
        send_request

        stock_history.reload

        expect(json_response).to match(expected_response)
      end
    end
  end
end
