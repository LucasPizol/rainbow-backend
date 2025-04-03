class Web::SearchController < Web::ApplicationController
  helper Ransack::Helpers::FormHelper

  def index
    @q = Product.ransack(params[:q])
    @products = @q.result.includes(:category, :subcategories, images_attachments: :blob)
  end
end
