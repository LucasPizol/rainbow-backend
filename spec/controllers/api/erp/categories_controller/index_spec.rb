# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::Erp::CategoriesController, :unit, type: :controller do
  render_views

  subject(:send_request) { get :index, format: :json }

  it { expect(described_class).to be < ApplicationController }

  it_behaves_like 'unauthenticated'

  context "when the user is authenticated" do
    let!(:user) { create(:user) }
    before do
      authenticate_user(user)
      create_list(:category, 3)
    end

    context "when the categories are returned" do
      it { is_expected.to have_http_status(:ok) }

      let(:expected_response) do
        {
          categories: Category.all.map do |category|
            {
              id: category.id,
              name: category.name
            }
          end
        }
      end

      it 'returns the categories' do
        send_request

        expect(json_response).to match(expected_response)
      end
    end
  end
end
