# frozen_string_literal: true

class Api::Erp::Orders::ReportController < Api::ApplicationController
  def index
    @order_report = Order
                   .select("orders.total, strftime('%m', orders.created_at) AS month, SUM(orders.total) AS total")
                   .group('month')

    @exit_report = StockHistory
                   .where("operation = ?", StockHistory.operations[:entry])
                   .select("stock_histories.quantity,
                            strftime('%m', stock_histories.created_at) AS month,
                            SUM(stock_histories.quantity * stock_histories.price) AS total"
                          )
                   .group('month')

    @average_ticket_by_product = OrderProduct
                                  .joins(:order, :product)
                                  .where("orders.status = ?", Order.statuses[:completed])
                                  .select("order_products.product_id,
                                            products.name,
                                            SUM(order_products.quantity * order_products.price) AS total,
                                            strftime('%m', orders.created_at) AS month")
                                  .group('month')
                                  .group('order_products.product_id')
                                  .group('products.name')
                                  .order('total DESC')
  end
end
