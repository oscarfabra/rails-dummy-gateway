module CurrentOrder
  extend ActiveSupport::Concern

  private

    def set_order
      # Assumes that order to process is the last one in the db.
      # Should add constraints to avoid concurrency issues.
      @order = Order.last
    rescue ActiveRecord::RecordNotFound
      @order = Order.create
      logger.info "New order object: #{@order}"
      session[:order_id] = @order.id
    end
end