module CurrentOrder
  extend ActiveSupport::Concern

  private

    def set_order
      # Assumes that order to process is the last one in the db.
      # TODO: Should add constraints to avoid concurrency issues.
      @order = Order.last
      session[:order_id] = @order.id
    end
end