# frozen_string_literal: true

class Api::Erp::SubcategoriesController < Api::ApplicationController
  before_action :set_category, only: %i[show update destroy]

  def index
    @subcategories = Subcategory.all
  end

  def show; end

  def create
    @subcategory = Subcategory.new(subcategory_params)

    @subcategory.save!

    render :show, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors }, status: :unprocessable_entity
  end

  def update
    @subcategory.update!(subcategory_params)

    render :show, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotSaved => e
    render json: { message: e.record.errors.full_messages.to_sentence }, status: :unprocessable_entity
  end

  def destroy
    @subcategory.destroy!
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: { message: e.record.errors.full_messages.to_sentence }, status: :unprocessable_entity
  end

  private

  def set_category
    @subcategory = Subcategory.find(params[:id])
  rescue
    render json: { message: 'Subcategoria não encontrada' }, status: :not_found
  end

  def subcategory_params
    params.require(:subcategory).permit(:name)
  end
end
