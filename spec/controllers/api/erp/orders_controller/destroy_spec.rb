
require "spec_helper"

RSpec.describe Api::Erp::OrdersController, :unit, type: :controller do
  render_views

  subject(:send_request) { delete :destroy, params: params, format: :json }

  it { expect(described_class).to be < ApplicationController }

  it_behaves_like 'unauthenticated'

  context "when the user is authenticated" do
    let(:user) { create(:user) }
    before { authenticate_user(user) }

    context "when the order exists" do
      let!(:order) { create(:order) }

      let(:params) { { id: order.id } }

      it { is_expected.to have_http_status(:no_content) }
      it { expect { send_request }.to change(Order, :count).by(-1) }
    end

    context "when the order does not exist" do
      let(:params) { { id: 0 } }

      it { is_expected.to have_http_status(:not_found) }

      it 'returns an error message' do
        send_request

        expect(JSON.parse(response.body)).to eq({ "message" => "Pedido não encontrado" })
      end
    end
  end
end
