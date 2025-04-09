
require 'mercadopago'

class Checkout::MercadoPago < Checkout
  def call(
    payment_method_id:,
    installments:,
    token:,
    email:,
    identification_type:,
    identification_number:)

    cart_total = @client.cart_items.includes(:product).sum(&:total_price)

    sdk = ::Mercadopago::SDK.new(ENV.fetch('MERCADO_PAGO_ACCESS_TOKEN'))

    payment_data = {
      transaction_amount: @client.total_cart_items.to_f,
      token: token,
      installments: installments.to_i,
      payment_method_id: payment_method_id,
      payer: {
        email: email,
        identification: {
          type: identification_type,
          number: identification_number
        }
      }
    }

    payment_response = sdk.payment.create(payment_data)
    payment_response[:response]
  end
end
