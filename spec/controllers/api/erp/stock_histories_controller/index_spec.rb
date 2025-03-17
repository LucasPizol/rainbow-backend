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
        data: StockHistory.all.as_json.map(&:deep_symbolize_keys),
        page: 1,
        pages: 1,
        total: 3
      }
    end

    it 'returns the stock histories' do
      send_request

      expect(json_response).to match(expected_response)
    end
  end
end
