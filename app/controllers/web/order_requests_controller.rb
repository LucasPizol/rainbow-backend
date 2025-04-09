# frozen_string_literal: true

class Web::OrderRequestsController < Web::ApplicationController
  def index
    @order_requests = current_client.order_requests.includes(order_request_items: :product)

    render :index
  end
end
