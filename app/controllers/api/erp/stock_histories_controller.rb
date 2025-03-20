# frozen_string_literal: true

class Api::Erp::StockHistoriesController < ApplicationController
  before_action :set_stock_history, only: :destroy
  before_action :set_pagination, only: :index

  def index
    @stock_histories = StockHistory.page(@page).per(@per_page).order(created_at: :desc)
  end

  def create
    @stock_history = StockHistory.new(stock_history_params.merge(operation: StockHistory.operations[:entry]))

    @stock_history.save!

    render :create, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors }, status: :unprocessable_entity
  end

  def destroy
    @stock_history.destroy!
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: { message: e.record.errors.full_messages.to_sentence }, status: :unprocessable_entity
  end

  private

  def set_stock_history
    @stock_history = StockHistory.find(params[:id])
  rescue
    render json: { message: 'Histórico do estoque não encontrado' }, status: :not_found
  end

  def stock_history_params
    params.require(:stock_history).permit(:product_id, :quantity, :price, :description)
  end
end
