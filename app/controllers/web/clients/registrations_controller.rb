class Web::Clients::RegistrationsController < Web::ApplicationController
  respond_to :html, :json

  def new
    @resource = Client.new
    @resource_name = :client
    @devise_mapping = Devise.mappings[:client]
    render :new
  end

  def create
    @resource_name = :client
    @resource = Client.new(sign_up_params)
    @resource.save!
    @devise_mapping = Devise.mappings[:client]
    redirect_to root_url
  rescue => e
    flash[:alert] = e.message
    render :new, status: :unprocessable_entity
  end

  protected

  def after_sign_up_path_for(resource)
    root_url
  end

  def sign_up_params
    params.require(:client).permit(:name, :email, :password, :password_confirmation, :document, :phone)
  end
end
