# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::Erp::CategoriesController, :unit, type: :controller do
  render_views

  subject(:send_request) { post :create, params: params, format: :json }

  it { expect(described_class).to be < ApplicationController }

  it_behaves_like 'unauthenticated'

  context "when the user is authenticated" do
    let!(:user) { create(:user) }
    before { authenticate_user(user) }

    context "when the category is created" do
      let(:params) { { category: { name: 'Category 1' } } }

      it { is_expected.to have_http_status(:created) }

      let(:expected_response) do
        {
          category: {
            id: category.id,
            name: category.name
          }
        }
      end

      let(:category) { Category.last }

      it 'returns the category' do
        send_request

        category.reload

        expect(json_response).to match(expected_response)
      end

      it { expect { send_request }.to change(Category, :count).by(1) }
      it { expect { send_request }.to change(PaperTrail::Version, :count).by(1) }
    end
  end
end
