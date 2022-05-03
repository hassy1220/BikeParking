class CommentMailer < ApplicationMailer
  def send_comment
    @customer = Customer.find(params[:customer])
    @park = Park.find(params[:park])
    mail(to: @customer.email, subject: 'コメントがきました')
  end
end
