
require "spec_helper"

RSpec.describe Api::Erp::OrderProductsController, :unit, type: :controller do
  render_views

  subject(:send_request) { delete :destroy, params: params, format: :json }

  it { expect(described_class).to be < ApplicationController }

  it_behaves_like 'unauthenticated'

  context "when the user is authenticated" do
    let(:user) { create(:user) }
    before { authenticate_user(user) }

    context "when the order product exists" do
      let!(:order_product) { create(:order_product) }

      let(:params) { { id: order_product.id } }

      it { is_expected.to have_http_status(:no_content) }
      it { expect { send_request }.to change(OrderProduct, :count).by(-1) }
    end

    context "when the order product does not exist" do
      let(:params) { { id: 0 } }

      it { is_expected.to have_http_status(:not_found) }

      it 'returns an error message' do
        send_request

        expect(json_response).to eq({ message: "Produto do pedido não encontrado" })
      end
    end
  end
end
