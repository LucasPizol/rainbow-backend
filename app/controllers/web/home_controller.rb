class Web::HomeController < Web::ApplicationController
  helper Ransack::Helpers::FormHelper

  def index
    @q = Product.ransack(params[:q])

    @products = @q.result.includes(
      subcategory_products: :subcategory,
      images_attachments: :blob
    )

    @carousel_products = @products.sample(5)
    render :index
  end
end
