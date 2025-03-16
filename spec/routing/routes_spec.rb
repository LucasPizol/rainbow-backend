# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Routes', type: :routing do
  describe 'authentication' do
    describe '/api/erp/login' do
      it 'routes to api/erp/login#create' do
        expect(post: '/api/erp/login').to route_to('api/erp/login#create', format: :json)
      end
    end
  end
end
