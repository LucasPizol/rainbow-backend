# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::Erp::SubcategoriesController, :unit, type: :controller do
  render_views

  subject(:send_request) { delete :destroy, params: params, format: :json }

  it { expect(described_class).to be < ApplicationController }

  it_behaves_like 'unauthenticated'

  context "when the user is authenticated" do
    let!(:user) { create(:user) }
    before { authenticate_user(user) }

    context "when sucessfully updating the subcategory" do
      let!(:subcategory) { create(:subcategory) }
      let(:params) { { id: subcategory.id } }

      it { is_expected.to have_http_status(:no_content) }
      it { expect { send_request }.to change(Subcategory, :count).by(-1) }
      it { expect { send_request }.to change(PaperTrail::Version, :count).by(1) }
    end

    context "when the subcategory is not found" do
      let(:params) { { id: 999 } }

      it { is_expected.to have_http_status(:not_found) }

      let(:expected_response) { { message: 'Subcategoria não encontrada' } }

      it 'returns the error message' do
        send_request

        expect(json_response).to match(expected_response)
      end
    end

    context "when the subcategory has products associated" do
      let!(:subcategory) { create(:subcategory) }
      let!(:product) { create(:product, subcategory: subcategory) }
      let(:params) { { id: subcategory.id } }

      it { is_expected.to have_http_status(:unprocessable_entity) }

      let(:expected_response) do
        { message: 'Não é possível excluir ou alterar uma subcategoria com produtos associados' }
      end

      it 'returns the error message' do
        send_request

        expect(json_response).to match(expected_response)
      end
    end
  end
end
