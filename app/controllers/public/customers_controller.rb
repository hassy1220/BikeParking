class Public::CustomersController < ApplicationController
  def index
    @customers = Customer.all
  end
  def show
    @customer = Customer.find(params[:id])
  end
  def edit
    @customer = Customer.find(params[:id])
  end
  def update
    customer = Customer.find(params[:id])
    if customer.update(customer_params)
      redirect_to public_customer_path(customer.id)
    else
      flash[:danger]=customer.errors.full_messages
      redirect_to request.referer
    end
  end


  private
  def customer_params
    params.require(:customer).permit(:name,:description,:bike_image)
  end

end
