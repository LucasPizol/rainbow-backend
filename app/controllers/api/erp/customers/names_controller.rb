# frozen_string_literal: true

class Api::Erp::Customers::NamesController < Api::ApplicationController
  def index
    @customers = Customer.select(:id, :name).ransack(search_params).result
  end

  def search_params
    params.fetch(:search, {}).permit(:name_cont)
  end
end
