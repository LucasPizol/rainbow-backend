class Web::Checkout::ErrorController < Web::ApplicationController
  def index
    flash[:alert] = "Ocorreu um erro ao processar o pagamento. Por favor, tente novamente."
  end
end
