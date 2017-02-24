class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service, only: [:new, :create, :show, :edit, :update]

  def new
  	@order = @service.orders.new
  end

  def create
  	@order = current_user.orders.create(order_params)
  	@order.total_price = params[:order][:price].to_i * params[:order][:quantity].to_i
  	token = params[:stripeToken]
  	puts "hello"
  	puts token
    charge = Stripe::Charge.create source: params[:stripeToken],
                          amount: @order.total_price * 100,
                          description: @service.title,
                          currency: 'usd'
  	if @order.save
  	  flash[:success] = "Your Order has been created successfully with charge_id #{charge[:id]}"
      redirect_to user_orders_path
    else
      flash[:danger] = "Couldn't create the order"
      render 'services/show'
    end  
  end

  def user_orders
    @orders = current_user.orders
  end

  private

  def set_service
    @service = Service.find(params[:service_id])
  end

  def order_params
  	params.require(:order).permit(:price, :quantity, :service_id)
  end

end
