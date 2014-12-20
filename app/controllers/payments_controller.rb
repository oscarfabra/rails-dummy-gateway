class PaymentsController < ApplicationController

  include CurrentOrder
  include CurrentClient
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

    # Validates pre-condition order data.
    payment = params[:payment]  # Stores payment hash.
    logger.info "payment = #{payment}"
    logger.info "payment['order_id'] = #{payment['order_id']}"
    if payment['order_id'].size == 0 || payment['amount'] == 0.0
      logger.info "No order to pay. About to redirect..."
      redirect_to pay_path, notice: 'No order to pay.' and return
    end

    # Searches for payment.
    @payment = Payment.find_by(order_id: payment['order_id'])
    logger.info "@payment = #{@payment}"
    if !@payment.nil?
      redirect_to pay_path, notice: 'This order has already been paid.' and return
    end

    # Processes a new payment.
    @payment = Payment.new(payment_params)
    logger.info "Attributes about to be saved: #{@payment.attributes}"
    logger.info "Amount = #{@payment.amount}"
    logger.info "Errors = #{@payment.errors.count}"

    if !@payment.valid? || @payment.errors.count > 0
      redirect_to pay_path,
                  notice: 'Credit card validation failed. Please check your details.' and return

    elsif @payment.save! and @payment.process

      # Sends order details in json format back to the store.
      redirect_url = send_response('SUCCESS', :json)

      redirect_to redirect_url,
                   notice: 'Payment was successfully made.' and return
    else

      # Sends order details in json format back to the store.
      redirect_url = send_response('FAIL', :json)

      redirect_to redirect_url,
                   notice: "Payment couldn't be made." and return
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
