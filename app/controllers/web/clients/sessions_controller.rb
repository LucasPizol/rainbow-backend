class Web::Clients::SessionsController < Web::ApplicationController
  include Devise::Controllers::Helpers

  def new
    @resource = Client.new
    @resource_name = :client
    @devise_mapping = Devise.mappings[:client]

    render :new
  end

  def create
    @resource_name = :client
    @resource = Client.find_by(email: params[:client][:email])

    if @resource && @resource.valid_password?(params[:client][:password])
      sign_in(@resource)
      redirect_to root_url
    else
      flash[:alert] = "Email ou senha inválidos"
      redirect_to new_client_session_url
    end
  end

  def destroy
    sign_out(@resource)
    redirect_to new_client_session_url
  end
end
