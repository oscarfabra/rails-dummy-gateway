require 'rest_client'

class OrderReaderController < ApplicationController

  protect_from_forgery with: :null_session,
                       if: Proc.new { |c| c.request.format.json? }

  # GET /read_order
  # GET /read_order.json
  def new

  end

  # POST /read_order
  # POST /read_order.json
  def create
    logger.info "Received data: #{params}"

    # Saves params into session for later retrieval.
    @order = Order.new(params[:order_reader])

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
end
