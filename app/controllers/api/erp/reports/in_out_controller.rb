# frozen_string_literal: true

class Api::Erp::Reports::InOutController < Api::ApplicationController
  def index
    @order_report = Order
                        .where("orders.status = ?", Order.statuses[:completed])
                        .ransack(order_search_params)
                        .result
                        .select("orders.total, strftime('%m', orders.created_at) AS month, SUM(orders.total) AS total")
                        .group('month')

    @exit_report = StockHistory
                              .where("operation = ?", StockHistory.operations[:entry])
                              .ransack(stock_search_params)
                              .result
                              .select("
                                        strftime('%m', stock_histories.created_at) AS month,
                                        SUM(stock_histories.quantity * stock_histories.price) AS total
                                      ")
                              .group('month')
  end

  def search_params
    params.fetch(:search, {}).permit(:month, :year, product_id_in: [], order_products_product_id_in: [])
  end

  def stock_search_params
    search_params.except(:order_product_product_id_in)
  end

  def order_search_params
    search_params.except(:product_id_in)
  end
end
