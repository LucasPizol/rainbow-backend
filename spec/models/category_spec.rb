# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#

# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Category, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to have_many(:products) }
  end

  context "callbacks" do
    describe "check_for_products" do
      let(:category) { create(:category) }
      let!(:product) { create(:product, category: category) }

      it "cannot delete category with products" do
        expect { category.destroy }.not_to change(Category, :count)
      end

      it "cannot change category name with products" do
        expect { category.update(name: "New Name") }.not_to change { category.reload.name }
      end
    end
  end
end
