# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Routes', type: :routing do
  describe 'login' do
    it_behaves_like 'routes', route: '/api/erp/login', actions: %i[create]
  end

  describe 'categories' do
    it_behaves_like 'routes', route: '/api/erp/categories', actions: %i[create show update destroy index]
  end

  describe 'subcategories' do
    it_behaves_like 'routes', route: '/api/erp/subcategories', actions: %i[create show update destroy index]
  end

  describe 'products' do
    it_behaves_like 'routes', route: '/api/erp/products', actions: %i[index create show update destroy]
  end

  describe 'orders' do
    it_behaves_like 'routes', route: '/api/erp/orders', actions: %i[index create show update destroy]
  end

  describe 'customers' do
    it_behaves_like 'routes', route: '/api/erp/customers', actions: %i[index create show update destroy]
  end
end
