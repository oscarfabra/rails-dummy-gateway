class PaymentsController < ApplicationController

  protect_from_forgery with: :null_session,
                       if: Proc.new { |c| c.request.format.json? }

  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  # GET /payments
  # GET /payments.json
  def index
    @payments = Payment.all
    redirect_to pay_path, notice: "Can't view all payments."
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
    # session[:total] = 100  # Test data
  end

  # GET /payments/1/edit
  def edit
    redirect_to pay_path, notice: "Can't edit a payment that is already done."
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)

    respond_to do |format|
      if @payment.errors.empty? and @payment.save and @payment.process(params[:payment][:amount])
        notice = 'Payment was successfully done.'

        # Sends orders details in json format back to the store.
        RestClient.post "http://localhost:3000/orders", { :notice => notice }.to_json,
                        :content_type => :json, :accept => :json

        format.html { redirect_to @payment, notice: 'Payment was successfully done.' }
        format.json { render :show, status: :created, location: @payment }
      else
        # Sends orders details in json format back to the store.
        RestClient.post "http://localhost:3000/orders", { :notice => notice }.to_json,
                        :content_type => :json, :accept => :json

        format.html { redirect_to pay_path, notice: 'Credit card validation failed.'}
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /read_order
  # POST /read_order.json
  # def purchase
  #   logger.info '*' * 80
  #   logger.info "Received data: #{params}"
  #   logger.info '*' * 80
  #
  #   # Saves params into session for later retrieval.
  #   session[:total] = params[:total]
  #   session[:customer_id] = params[:customer_id]
  #   session[:order_no] = params[:order_no]
  #   session[:address] = params[:address]
  #   session[:email] = params[:email]
  #   session[:pay_type] = params[:pay_type]
  #
  #   respond_to do |format|
  #     if params
  #       format.html { redirect_to '/payments/new.html' }
  #       format.json do  # render an html page instead of a JSON response.
  #         redirect_to '/payments/new.html'
  #       end
  #     else
  #       format.html { redirect_to '/payments/new.html' }
  #       format.json { render json: params, status: :unprocessable_entity }
  #     end
  #   end
  # end

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

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.require(:payment).permit(:number, :month, :year, :first_name, :last_name, :verification_value)
    end
end
