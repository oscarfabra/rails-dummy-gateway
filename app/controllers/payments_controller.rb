class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  # GET /payments
  # GET /payments.json
  def index
    @payments = Payment.all
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
    redirect_to pay_path, notice: "Can't edit a payment that is already done."
    return
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)

    unless @payment.process
      redirect_to pay_path, notice: 'Credit Card Validation Failed.'
      return
    end

    respond_to do |format|
      if @payment.save
        format.html { redirect_to @payment, notice: 'Payment was successfully done.' }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { render :new }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    redirect_to pay_path, notice: "Can't update a payment."
    return
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    redirect_to pay_path, notice: "Can't destroy a payment."
    return
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.require(:payment).permit(:number, :month, :year, :first_name, :last_name, :verification_value)
    end
end
