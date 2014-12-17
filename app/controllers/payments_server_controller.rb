require 'rest_client'

class PaymentsServerController < ApplicationController

  include CurrentClient  # Used to know which client to serve.

  protect_from_forgery with: :null_session,
                       if: Proc.new { |c| c.request.format.json? }

  # GET /read_order
  # GET /read_order.json
  def new

  end

  # POST /read_order
  # POST /read_order.json
  def read_order
    # TODO: Should update to handle multiple Client requests.
    logger.info "Received data: #{params}"
    logger.info "payments_server hash: #{params[:payments_server]}"

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

  # GET /send_response
  def send_response
    # Redirects to client waiting for the answer.
    redirect_to CurrentClient::RESPONSE_URL
  end

  private

    # Only allow the white list through.
    def order_reader_params
      params.require(:payments_server).permit(:total,
                                    :customer_id,
                                    :order_no,
                                    :address,
                                    :email,
                                    :pay_type)
    end

end
