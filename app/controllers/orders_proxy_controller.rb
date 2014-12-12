require 'rest_client'

class OrdersProxyController < ApplicationController

  protect_from_forgery with: :null_session,
                       if: Proc.new { |c| c.request.format.json? }

  # GET /read_order
  # GET /read_order.json
  def new

  end

  # POST /read_order
  # POST /read_order.json
  def read_order
    logger.info "Received data: #{params}"
    logger.info "orders_proxy hash: #{params[:orders_proxy]}"

    # Creates a new order for later retrieval.
    order = Order.new(order_reader_params)

    respond_to do |format|
      if order.save!
        session[:order_id] = order.id
        format.html { redirect_to '/payments/new.html' }
        format.json do  # render an html page instead of a JSON response.
          redirect_to '/payments/new.html'
        end
      else
        format.html { redirect_to '/payments/new.html' }
        format.json { render json: params, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forget_order/1
  # DELETE /forget_order/1.json
  def destroy
  end

  private

    # Only allow the white list through.
    def order_reader_params
      params.require(:orders_proxy).permit(:total,
                                    :customer_id,
                                    :order_no,
                                    :address,
                                    :email,
                                    :pay_type)
    end

end
