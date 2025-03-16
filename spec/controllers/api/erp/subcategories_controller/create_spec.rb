# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::Erp::SubcategoriesController, :unit, type: :controller do
  render_views

  subject(:send_request) { post :create, params: params, format: :json }

  it { expect(described_class).to be < ApplicationController }

  it_behaves_like 'unauthenticated'

  context "when the user is authenticated" do
    let!(:user) { create(:user) }
    before { authenticate_user(user) }

    context "when the subcategory is created" do
      let(:params) { { subcategory: { name: 'Subcategory 1' } } }

      it { is_expected.to have_http_status(:created) }

      let(:expected_response) do
        {
          subcategory: {
            id: subcategory.id,
            name: subcategory.name
          }
        }
      end

      let(:subcategory) { Subcategory.last }

      it 'returns the subcategory' do
        send_request

        subcategory.reload

        expect(json_response).to match(expected_response)
      end

      it { expect { send_request }.to change(Subcategory, :count).by(1) }
      it { expect { send_request }.to change(PaperTrail::Version, :count).by(1) }
    end
  end
end
