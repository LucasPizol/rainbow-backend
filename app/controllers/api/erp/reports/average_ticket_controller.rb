# frozen_string_literal: true

class Api::Erp::Reports::AverageTicketController < ApplicationController
  def index
    average_tickets = Product
                              .ransack(search_params)
                              .result
                              .joins("LEFT JOIN order_products ON order_products.product_id = products.id")
                              .joins("LEFT JOIN orders ON orders.id = order_products.order_id")
                              .select("
                                strftime('%m', orders.created_at) AS month,
                                SUM(order_products.quantity * CAST(order_products.price AS REAL)) / NULLIF(SUM(order_products.quantity), 0) AS average
                              ")
                              .group('month')

    average_exits = Product
                            .ransack(search_params)
                            .result
                            .joins("LEFT JOIN stock_histories ON stock_histories.product_id = products.id")
                            .select("
                              strftime('%m', stock_histories.created_at) AS month,
                              SUM(CASE WHEN stock_histories.operation = #{StockHistory.operations[:entry]} THEN stock_histories.quantity * CAST(stock_histories.price AS REAL) ELSE 0 END) / NULLIF(SUM(CASE WHEN stock_histories.operation = #{StockHistory.operations[:entry]} THEN stock_histories.quantity ELSE 0 END), 0) AS cost
                            ")
                            .group('month')

    @average_ticket_by_product = (1..12).map do |month|
      average_ticket = average_tickets.find { |t| t.month.to_i == month }&.average
      average_exit = average_exits.find { |e| e.month.to_i == month }&.cost

      if average_ticket.nil?
        previous_tickets = average_tickets.select { |t| t.month.to_i < month }.map(&:average).compact
        average_ticket = previous_tickets.sum / (previous_tickets.size.nonzero? || 1).to_f
      end

      if average_exit.nil?
        previous_exits = average_exits.select { |e| e.month.to_i < month }.map(&:cost).compact
        average_exit = previous_exits.sum / (previous_exits.size.nonzero? || 1).to_f
      end

      {
        month: month,
        average: average_ticket || 0,
        cost: average_exit || 0
      }
    end
  end

  def search_params
    params.fetch(:search, {}).permit(:month, :year, id_in: [])
  end
end
