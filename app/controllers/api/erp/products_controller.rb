# frozen_string_literal: true

class Api::Erp::ProductsController < ApplicationController
  before_action :set_pagination, only: %i[index]
  before_action :set_product, only: %i[show destroy update]

  def index
    @categories = Product.page(@page).per(@per_page)
  end

  def create
    @product = Product.new(product_params.merge(status: "active"))

    ActiveRecord::Base.transaction do
      @category = Category.create!(category_params) if category_params.present?
      @subcategory = Subcategory.create!(subcategory_params) if subcategory_params.present?

      @product.category = @category if @category.present?
      @product.subcategory = @subcategory if @subcategory.present?

      @product.save!
    end

    render :show, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors }, status: :unprocessable_entity
  end

  def show; end

  def destroy
    @product.destroy!
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: { message: e.record.errors.full_messages.to_sentence }, status: :unprocessable_entity
  end

  def update
    @product.update!(product_params)

    render :show, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors }, status: :unprocessable_entity
  end

  private

  def set_product
    @product = Product.find(params[:id])
  rescue
    render json: { message: "Produto não encontrado" }, status: :not_found
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :category_id, :subcategory_id, :stock, images: [])
  end

  def category_params
    params.fetch(:category, {}).permit(:name)
  end

  def subcategory_params
    params.fetch(:subcategory, {}).permit(:name)
  end
end
