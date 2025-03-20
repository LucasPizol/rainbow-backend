# frozen_string_literal: true

class Api::Erp::Orders::StatusController < ApplicationController
  def index
    @orders = Order.select("orders.status, COUNT(orders.status) AS count")
                   .group('status')
  end
end
