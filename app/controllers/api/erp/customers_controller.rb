# frozen_string_literal: true

class Api::Erp::CustomersController < Api::ApplicationController
  before_action :set_customer, only: %i[show update destroy]
  before_action :set_pagination, only: %i[index]

  def index
    @customers = Customer.page(@page).per(@per_page)
  end

  def show; end

  def create
    @customer = Customer.new(customer_params)
    @customer.save!

    render :show, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors }, status: :unprocessable_entity
  end

  def update
    @customer.update!(customer_params)
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors }, status: :unprocessable_entity
  end

  def destroy
    @customer.destroy!
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: { message: e.record.errors.full_messages.to_sentence }, status: :unprocessable_entity
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  rescue
    render json: { message: "Cliente não encontrado" }, status: :not_found
  end

  def customer_params
    params.require(:customer).permit(:name, :email, :phone, :address)
  end
end
