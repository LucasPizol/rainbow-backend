
require "spec_helper"

RSpec.describe Api::Erp::StockHistoriesController, :unit, type: :controller do
  render_views

  subject(:send_request) { delete :destroy, params: params, format: :json }

  it { expect(described_class).to be < ApplicationController }

  it_behaves_like 'unauthenticated'

  context "when the user is authenticated" do
    let(:user) { create(:user) }
    before { authenticate_user(user) }

    context "when the stock history exists" do
      let!(:stock_history) { create(:stock_history) }

      let(:params) { { id: stock_history.id } }

      it { is_expected.to have_http_status(:no_content) }
      it { expect { send_request }.to change(StockHistory, :count).by(-1) }
    end

    context "when the stock history does not exist" do
      let(:params) { { id: 0 } }

      it { is_expected.to have_http_status(:not_found) }

      it 'returns an error message' do
        send_request

        expect(json_response).to eq({ message: "Histórico do estoque não encontrado" })
      end
    end
  end
end
