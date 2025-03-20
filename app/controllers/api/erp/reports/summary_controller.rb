# frozen_string_literal: true

class Api::Erp::Reports::SummaryController < ApplicationController
  def index
    @customers_count = Customer.count
    @orders_count = Order.count

    @entries = Order.where("orders.status = ?", Order.statuses[:completed]).sum(:total)
    @exits = StockHistory.where("operation = ?", StockHistory.operations[:entry]).sum("quantity * price")
    @balance = @entries - @exits
  end
end
