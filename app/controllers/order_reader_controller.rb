require 'rest_client'

class OrderReaderController < ApplicationController
  # GET /read_order
  # GET /read_order.json
  def new

  end

  # POST /read_order
  # POST /read_order.json
  def create
    # @product = Product.new(product_params)

    logger.info "Received data #{params}"

    # TODO: Process data.

    respond_to do |format|
      if @product.save
        format.html { redirect_to pay_path, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forget_order/1
  # DELETE /forget_order/1.json
  def destroy
  end
end
