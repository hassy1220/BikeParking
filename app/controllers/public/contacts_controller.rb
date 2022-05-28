class Public::ContactsController < ApplicationController
  include AjaxHelper
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.send_mail(@contact).deliver_now
      respond_to do |format|
        format.js { render ajax_redirect_to(root_path) }
      end
    else
      render :error
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :phone_number, :subject, :message)
  end
end
