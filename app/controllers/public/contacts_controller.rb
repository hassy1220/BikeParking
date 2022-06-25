class Public::ContactsController < ApplicationController
  include AjaxHelper
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.send_mail(@contact).deliver_now
      flash[:notice] = "お問合せ完了しました"
      # form_withにて非同期通信するよう設定しているが、redirectさせたい為、以下の記述にてredirectさせる
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
