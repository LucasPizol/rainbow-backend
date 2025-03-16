# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::Erp::CategoriesController, :unit, type: :controller do
  render_views

  subject(:send_request) { put :update, params: params, format: :json }

  it { expect(described_class).to be < ApplicationController }

  it_behaves_like 'unauthenticated'

  context "when the user is authenticated" do
    let!(:user) { create(:user) }
    before { authenticate_user(user) }

    context "when sucessfully updating the category" do
      let!(:category) { create(:category) }
      let(:params) { { id: category.id, category: { name: 'Category 2' } } }

      it { is_expected.to have_http_status(:ok) }

      let(:expected_response) do
        {
          category: {
            id: category.id,
            name: category.name
          }
        }
      end

      it 'returns the category' do
        send_request

        category.reload

        expect(json_response).to match(expected_response)
      end

      it { expect { send_request }.to change(PaperTrail::Version, :count).by(1) }
    end

    context "when the category is not found" do
      let(:params) { { id: 999, category: { name: 'Category 1' } } }

      it { is_expected.to have_http_status(:not_found) }

      let(:expected_response) { { message: 'Categoria não encontrada' } }

      it 'returns the error message' do
        send_request

        expect(json_response).to match(expected_response)
      end
    end

    context "when the category has products associated" do
      let!(:category) { create(:category) }
      let!(:product) { create(:product, category: category) }
      let(:params) { { id: category.id, category: { name: 'Category 2' } } }

      it { is_expected.to have_http_status(:unprocessable_entity) }

      let(:expected_response) do
        { message: 'Não é possível excluir ou alterar uma categoria com produtos associados' }
      end

      it 'returns the error message' do
        send_request

        expect(json_response).to match(expected_response)
      end
    end
  end
end
