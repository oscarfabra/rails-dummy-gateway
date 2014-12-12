class PaymentsController < ApplicationController

  include CurrentOrder
  before_action :set_order, only: [:new, :create, :show]
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  protect_from_forgery with: :null_session,
                       if: Proc.new { |c| c.request.format.json? }

  # GET /payments
  # GET /payments.json
  def index
    @payments = Payment.all
    redirect_to pay_path, notice: "Can't view payments."
  end

  # GET /payments/1
  # GET /payments/1.json
  def show

  end

  # GET /payments/new
  def new
    @payment = Payment.new
    @payment.order = @order
    @payment.order_id = @order.id
    # Assumes order payment will be made all at once.
    @payment.amount = @order.total
  end

  # GET /payments/1/edit
  def edit
    redirect_to pay_path, notice: "Can't edit a payment that is already done."
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)
    logger.info "Attributes about to be saved: #{@payment.attributes}"
    logger.info "amount = #{@payment.amount}"

    respond_to do |format|
      if @payment.paid?
        format.html { redirect_to pay_path, notice: 'This order has already been paid.'}
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      elsif @payment.errors.empty? and @payment.save! and @payment.process

        # Sends orders details in json format back to the store.
        RestClient.post "http://localhost:3000/orders",
                        { notice: 'Payment was successfully done.' }.to_json,
                        :content_type => :json, :accept => :json

        # format.html { redirect_to @payment, notice: 'Payment was successfully done.' }
        # format.json { render :show, status: :created, location: @payment }
      else
        if @payment.errors.empty?
          # Sends orders details in json format back to the store.
          RestClient.post "http://localhost:3000/orders",
                          { notice: 'Credit card validation failed.' }.to_json,
                          :content_type => :json,
                          :accept => :json
        else
          format.html { redirect_to pay_path, notice: 'Credit card validation failed.'}
          format.json { render json: @payment.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    redirect_to pay_path, notice: "Can't update a payment."
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    redirect_to pay_path, notice: "Can't destroy a payment."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Only allow the white list through.
    def payment_params
      params.require(:payment).permit(:number,
                                      :month,
                                      :year,
                                      :first_name,
                                      :last_name,
                                      :verification_value,
                                      :status,
                                      :order_id,
                                      :amount)
    end
end
