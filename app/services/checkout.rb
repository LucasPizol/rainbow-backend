class Checkout
  def initialize(
    client:,
    address:
    # card_number:,
    # card_exp_month:,
    # card_exp_year:,
    # card_cvc:
  )
    @client = client
    @address = address
    # @card_number = card_number
    # @card_exp_month = card_exp_month
    # @card_exp_year = card_exp_year
    # @card_cvc = card_cvc
  end

  def call
    raise "Not implemented"
  end
end
