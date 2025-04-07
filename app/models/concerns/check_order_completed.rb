module CheckOrderCompleted
  extend ActiveSupport::Concern

  included do
    before_save :check_can_update
    before_destroy :check_can_update
  end

  private

  def check_can_update
    if self.class.name == "Order"
      raise "Cannot update order" if completed? && !status_changed?
    else
      raise "Cannot update order product" if order.completed?
    end
  end
end
