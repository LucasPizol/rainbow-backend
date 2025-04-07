class Web::CartItemsController < Web::ApplicationController
  def create
    @cart_item = current_client.cart_items.find_or_initialize_by(product_id: params[:product_id])
    @cart_item.quantity = @cart_item.quantity.to_i + 1

    if @cart_item.save
      if request.format.json?
        render json: { message: "Produto adicionado ao carrinho com sucesso!" }, status: :created
      else
        flash[:notice] = "Produto adicionado ao carrinho com sucesso!"
        redirect_back(fallback_location: root_path)
      end
    else
      if request.format.json?
        render json: { message: "Erro ao adicionar produto ao carrinho" }, status: :unprocessable_entity
      else
        flash[:alert] = "Erro ao adicionar produto ao carrinho"
        redirect_back(fallback_location: root_path)
      end
    end
  end
end
