module CurrentOrder
  extend ActiveSupport::Concern

  private

    def set_order
      # Assumes that order to process is the last one in the db.
      # Should add constraints to avoid concurrency issues.
      @order = Order.last
      unless @order
        @order = Order.create
        logger.info "New order object id: #{@order.id}"
      end
      session[:order_id] = @order.id
    end
end