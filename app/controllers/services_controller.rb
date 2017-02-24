class ServicesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_service, only: [:show, :edit, :update]
  def index
    @services = current_user.services
  end

  def show
    @order = current_user.orders.new
  end

  def new
    @service = current_user.services.build
  end

  def create
    @service = current_user.services.build(service_params)
    if @service.save
      flash[:success] = "Your Service has been created successfully"
      redirect_to @service
    else
      flash[:danger] = "Couldn't create the service"
      redirect_to :back
    end
  end

  def edit
  end

  def update
    # TODO: Save the updated service. Redirect to an appropriate page if save fails.
  end

  private
  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:title, :requirements, :description, :price, :image)
  end
end
