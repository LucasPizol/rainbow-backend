# frozen_string_literal: true

class Api::Erp::ProductsController < Api::ApplicationController
  before_action :set_pagination, only: %i[index]
  before_action :set_product, only: %i[show destroy update]

  def index
    @products = Product
                      .ransack(search_params)
                      .result
                      .includes(:category, :subcategories, :images_attachments)
                      .order(name: :asc)
                      .page(@page).per(@per_page)
  end

  def create
    ActiveRecord::Base.transaction do
      @product = Product.create!(product_params.merge(status: :active, stock: 0).except(:subcategories, :images))
      @product.subcategories = Subcategory.where(id: product_params[:subcategories])
      @product.generate_stock_history(quantity: product_params[:stock]) if product_params[:stock]&.to_i&.positive?
    end

    @product.images.attach(product_params[:images]) if product_params[:images].present?
    render :show, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { message: e.message }, status: :unprocessable_entity
  end

  def show; end

  def destroy
    @product.destroy!
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: { message: e.record.errors.full_messages.to_sentence }, status: :unprocessable_entity
  rescue ActiveRecord::InvalidForeignKey => e
    render json: { message: "Produto não pode ser excluído, pois está associado a um pedido" }, status: :unprocessable_entity
  end

  def update
    @product.update!(update_params.except(:subcategories, :images, :images_to_remove))

    ActiveRecord::Base.transaction do
      @product.subcategories = Subcategory.where(id: update_params[:subcategories]) if update_params[:subcategories].present?

      update_params[:images_to_remove].each do |image_id|
        @product.images.find(image_id).purge
      end if update_params[:images_to_remove].present?

      @product.images.attach(update_params[:images]) if update_params[:images].present?
    end

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
    params.require(:product).permit(:name, :description, :price, :category_id, :stock, :minimum_stock, :cost_price, images: [], subcategories: [])
  end

  def update_params
    params.require(:product).permit(
      :name,
      :description,
      :price,
      :category_id,
      :stock,
      :minimum_stock,
      :cost_price,
      images: [],
      subcategories: [],
      images_to_remove: [])
  end

  def category_params
    params.fetch(:category, {}).permit(:name)
  end

  def subcategory_params
    params.fetch(:subcategory, {}).permit(:name)
  end

  def search_params
    params.fetch(:search, {}).permit(:name_or_category_name_or_subcategories_name_cont, :s)
  end
end
