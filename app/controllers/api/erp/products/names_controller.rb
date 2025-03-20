# frozen_string_literal: true

class Api::Erp::Products::NamesController < ApplicationController
  def index
    @products = Product
                      .ransack(search_params)
                      .result
                      .select(:id, :name, :price, :cost_price)
                      .includes(:images_attachments)
  end

  def search_params
    params.fetch(:search, {}).permit(:name_or_category_name_or_subcategories_name_cont)
  end
end
