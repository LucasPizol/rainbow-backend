# frozen_string_literal: true

class Api::Erp::ProductsController < ApplicationController
  before_action :set_pagination, only: %i[index]

  def index
    @categories = Product.page(@page).per(@per_page)
  end
end
