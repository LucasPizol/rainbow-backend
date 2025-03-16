# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  email           :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    context 'is valid with valid attributes' do
      let(:user) { create(:user) }

      it do
        expect(user).to be_valid
      end
    end

    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }

    context 'is not valid duplicated user' do
      let(:email) { Faker::Internet.email }
      let!(:user1) { create(:user, email: email) }
      let(:user2) { build(:user, email: email) }

      it { expect(user2).to_not(be_valid) }
    end
  end
end
