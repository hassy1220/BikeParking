class Public::NotificationsController < ApplicationController
  before_action :delete_message
  def index
    notifications = current_customer.passive_notifications.all
    @notification = notifications.where.not(visitor_id: current_customer.id)
    # インデックスを開いたってことは、通知は見たってことだから、チェックをtrueにする。※良いね連発で通知が爆発することを恐れて、DBに保存したままにしている。(存在チェックで連続投稿)
    # notifications.where(checked: false).each do |notification|
    #   notification.update(checked: true)
    # end
  end

  def destroy
    notification = Notification.find(params[:id])
    notification.destroy
    redirect_to request.referer
  end

  # 一週間以降のものは削除する(自分の)
  private

  def delete_message
    message = current_customer.passive_notifications.all.where.not(created_at: 1.week.ago.beginning_of_day..Time.zone.now.end_of_day)
    message.each do |list|
      debugger
      unless list.park.customer == current_customer
        list.destroy
      end
    end
  end
end
