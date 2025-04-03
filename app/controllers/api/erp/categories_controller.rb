# frozen_string_literal: true

class Api::Erp::CategoriesController < Api::ApplicationController
  before_action :set_category, only: %i[show update destroy]

  def index
    @categories = Category.all
  end

  def show; end

  def create
    @category = Category.new(category_params)

    @category.save!

    render :show, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors }, status: :unprocessable_entity
  end

  def update
    @category.update!(category_params)

    render :show, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotSaved => e
    render json: { message: e.record.errors.full_messages.to_sentence }, status: :unprocessable_entity
  end

  def destroy
    @category.destroy!
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: { message: e.record.errors.full_messages.to_sentence }, status: :unprocessable_entity
  end

  private

  def set_category
    @category = Category.find(params[:id])
  rescue
    render json: { message: 'Categoria não encontrada' }, status: :not_found
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
