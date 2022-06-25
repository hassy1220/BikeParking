class Public::NotificationsController < ApplicationController
  before_action :delete_message
  def index
    notifications = current_customer.passive_notifications.all.order(created_at: :desc)
    @notification = notifications.where.not(visitor_id: current_customer.id)
  end

  def destroy
    notification = Notification.find(params[:id])
    notification.destroy
    redirect_to request.referer
  end

# 一週間以降のものは削除する(自分の)
  private

  def delete_message
    time = 1.week.ago.beginning_of_day..Time.zone.now.end_of_day
    message = current_customer.passive_notifications.all.where.not(created_at: time)
    message.each do |list|
      unless list.park.customer == current_customer
        list.destroy
      end
    end
  end
end
