# frozen_string_literal: true

require "spec_helper"

RSpec.describe Api::Erp::ProductsController, :unit, type: :controller do
  render_views

  subject(:send_request) { put :update, params: params, format: :json }

  it { expect(described_class).to be < ApplicationController }

  it_behaves_like 'unauthenticated'

  context "when the user is authenticated" do
    let(:user) { create(:user) }
    before { authenticate_user(user) }

    context "when is successful" do
      let(:name) { Faker::Name.name }
      let!(:product) { create(:product) }

      let(:params) do
        {
          product: {
            name: name
          },
          id: product.id
        }
      end

      it { is_expected.to have_http_status(:ok) }
      it { expect { send_request }.to change { product.reload.name }.to(name) }
    end
  end
end
