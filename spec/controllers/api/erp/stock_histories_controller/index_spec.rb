# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::Erp::StockHistoriesController, :unit, type: :controller do
  render_views

  subject(:send_request) { get :index, format: :json }

  it { expect(described_class).to be < ApplicationController }

  it_behaves_like 'unauthenticated'

  context "when the user is authenticated" do
    let!(:user) { create(:user) }

    before do
      authenticate_user(user)
      create_list(:stock_history, 3)
    end


    it { is_expected.to have_http_status(:ok) }

    let(:expected_response) do
      {
        data: StockHistory.all.order(created_at: :desc).map do |stock_history|
          {
            id: stock_history.id,
            quantity: stock_history.quantity,
            price: stock_history.price,
            operation: stock_history.operation,
            createdAt: stock_history.created_at,
            product: {
              id: stock_history.product.id,
              name: stock_history.product.name
            }
          }
        end,
        page: 1,
        pages: 1,
        total: 3
      }
    end

    it 'returns the stock histories' do
      send_request

      expect(json_response).to eq(JSON.parse(expected_response.to_json, symbolize_names: true))
    end
  end
end
