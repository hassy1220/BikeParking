class Public::ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.customer_id = current_customer.id
    if @contact.save
      ContactMailer.send_mail(@contact).deliver_now
      redirect_to root_path
    else
      render :new
    end
  end

  private
  def contact_params
    params.require(:contact).permit(:email,:phone_number,:subject,:message)
  end
end
