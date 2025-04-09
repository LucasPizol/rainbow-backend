require 'mercadopago'

class Web::CheckoutController < Web::ApplicationController
  before_action :authenticate_client!

  def index
    if params[:address_id].blank?
      flash[:alert] = "Endereço não selecionado"
      redirect_to web_cart_items_address_index_path
      return
    end

    @address = current_client.addresses.find(params[:address_id])
    @cart_items = current_client.cart_items.includes(:product)
    @cart_total = current_client.total_cart_items
    @installments = 1.upto(12).map { |i| ["#{i}x de R$ #{'%.2f' % (@cart_total / i)}", i] }

    sdk = ::Mercadopago::SDK.new(ENV.fetch('MERCADO_PAGO_ACCESS_TOKEN'))

    preference_data = {
      items: @cart_items.map { |item| { title: item.product.name, unit_price: item.product.price.to_f, quantity: item.quantity } },
      back_urls: {
        success: web_success_index_url,
        failure: web_error_index_url,
        pending: "https://www.seusite.com/pending"
      },
      auto_return: 'approved'
    }

    preference = sdk.preference.create(preference_data)

    @preference_id = preference[:response]['id']

    render :index
  end

  def create
    ActiveRecord::Base.transaction do
      items = current_client.cart_items.includes(:product)
      card_total = items.sum(&:total_price)
      address = current_client.addresses.find(params[:address_id])

      order_request = current_client.order_requests.create!(
        address: address,
        total_price: card_total,
        payment_method: params[:payment_method],
        payment_status: :payment_pending,
        shipping_status: :shipping_pending,
        status: :pending
      )

      order_request.order_request_items.create!(
        items.map { |item| { product: item.product, quantity: item.quantity, price: item.product.price } }
      )

      @checkout = ::Checkout::MercadoPago.new(client: current_client, address: address)
      @checkout.call(
        payment_method_id: payment_params[:payment_method_id],
        installments: payment_params[:installments],
        token: payment_params[:token],
        email: payment_params[:email],
        identification_type: payment_params[:identification_type],
        identification_number: payment_params[:identification_number]
      )

      current_client.cart_items.destroy_all
    end
    render json: { success: true, redirect_url: web_success_index_url }
  rescue => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  private

  def payment_params
    permitted = [
      :token,
      :payment_method_id,
      :email,
      :identification_number,
      :identification_type,
      :installments
    ]

    params.require(:checkout).permit(permitted)
  end
end
