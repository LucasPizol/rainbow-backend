# frozen_string_literal: true

class Api::Erp::Reports::SummaryController < Api::ApplicationController
  def index
    @customers_count = Customer.count
    @orders_count = Order.count + OrderRequest.count

    @products_sold = OrderProduct.sum(:quantity) + OrderRequestItem.sum(:quantity)

    @entries = Order.completed.sum(:total) + OrderRequest.sum(:total_price)

    @exits = StockHistory.entry.sum("quantity * price")
    @balance = @entries - @exits
  end
end
