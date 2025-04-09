class Web::CartItemsController < Web::ApplicationController
  before_action :authenticate_client!

  def index
    @cart_items = current_client.cart_items

    render "web/cart_items/index"
  end

  def destroy
    @cart_item = current_client.cart_items.find(params[:id])
    @cart_item.destroy
    redirect_back(fallback_location: root_path)
  end

  def update
    @cart_item = current_client.cart_items.find(params[:id])
    @cart_item.update(quantity: params[:quantity])
    redirect_back(fallback_location: root_path)
  end

  def create
    @cart_item = current_client.cart_items.find_or_initialize_by(product_id: params[:product_id])
    @cart_item.quantity = @cart_item.quantity.to_i + 1

    @cart_item.save!

    flash[:notice] = "Produto adicionado ao carrinho com sucesso!"
    redirect_back(fallback_location: root_path)
  rescue => e
    flash[:alert] = e.message
    redirect_back(fallback_location: root_path)
  end
end
