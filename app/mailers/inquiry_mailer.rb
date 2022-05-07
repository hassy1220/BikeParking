class InquiryMailer < ApplicationMailer

  def send_mail(inquiry)
    @inquiry = inquiry
    @customer = customer.email
    mail(
      to: ENV["USERNAME"],
      from: @inquiry.email,
      subject: 'お問合せ通知'
      )
  end
end
