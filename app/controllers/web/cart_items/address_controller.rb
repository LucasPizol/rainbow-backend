class Web::CartItems::AddressController < Web::ApplicationController
  before_action :authenticate_client!

  def index
    @addresses = current_client.addresses
  end

  def new
    @address = current_client.addresses.new
  end

  def create
    @address = current_client.addresses.create!(address_params)

    flash[:notice] = "Endereço criado com sucesso"

    if params[:redirect_url].present?
      redirect_to params[:redirect_url]
    else
      redirect_to web_address_index_url
    end
  end

  private

  def address_params
    params.require(:address).permit(:street, :city, :state, :zip_code, :neighborhood, :number, :complement, :reference, :name)
  end
end
