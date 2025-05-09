# == Schema Information
#
# Table name: subcategories
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_subcategories_on_name  (name) UNIQUE
#

# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Subcategory, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to have_many(:products) }
  end

  context "callbacks" do
    describe "check_for_products" do
      let(:category) { create(:category) }
      let(:subcategory) { create(:subcategory) }
      let(:product) { create(:product, category: category) }
      let!(:subcategory_product) { create(:subcategory_product, subcategory: subcategory, product: product) }

      it "cannot delete subcategory with products" do
        expect { subcategory.destroy }.not_to change(Subcategory, :count)
      end

      it "cannot change subcategory name with products" do
        expect { subcategory.update(name: "New Name") }.not_to change { subcategory.reload.name }
      end
    end
  end
end
