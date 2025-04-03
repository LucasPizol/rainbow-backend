# frozen_string_literal: true

class Api::Erp::OrderProductsController < Api::ApplicationController
  before_action :set_order_product, only: %i[update destroy]

  def create
    @order_product = OrderProduct.new(order_products_params)
    @order_product.save!

    render :show, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors }, status: :unprocessable_entity
  end

  def update
    @order_product.update!(order_products_params.except(:order_id))

    render :show, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors }, status: :unprocessable_entity
  end

  def destroy
    @order_product.destroy!
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: { message: e.record.errors.full_messages.to_sentence }, status: :unprocessable_entity
  end

  private

  def set_order_product
    @order_product = OrderProduct.find(params[:id])
  rescue
    render json: { message: "Produto do pedido não encontrado" }, status: :not_found
  end

  def order_products_params
    params.require(:order_product).permit(:product_id, :order_id, :price, :quantity, :discount)
  end
end
