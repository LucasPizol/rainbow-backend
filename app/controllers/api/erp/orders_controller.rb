# frozen_string_literal: true

class Api::Erp::OrdersController < ApplicationController
  before_action :set_order, only: %i[show update destroy]
  before_action :set_pagination, only: %i[index]

  def index
    @orders = Order.ransack(filter_params)
                   .result
                   .includes(:customer, order_products: { product: :images_attachments })
                   .page(@page).per(@per_page)
  end

  def show; end

  def create
    @order = Order.new(order_params)
    @order.save!

    render :create, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors }, status: :unprocessable_entity
  end

  def update
    @order.update!(order_params)
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors }, status: :unprocessable_entity
  end

  def destroy
    @order.destroy!
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: { message: e.record.errors.full_messages.to_sentence }, status: :unprocessable_entity
  end

  private

  def set_order
    @order = Order.find(params[:id])
  rescue
    render json: { message: "Pedido não encontrado" }, status: :not_found
  end

  def order_params
    params.require(:order).permit(:status, :customer_id, order_products_attributes: %i[product_id quantity price])
  end

  def filter_params
    params.fetch(:search, {}).permit(
    :customer_name_or_customer_phone_or_customer_email_cont,
    :s,
    status_in: [])
  end
end
