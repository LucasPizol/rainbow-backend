class Web::Checkout::SuccessController < Web::ApplicationController
  def index
    flash[:notice] = "Pedido realizado com sucesso!"
  end
end
