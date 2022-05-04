class Public::NotificationsController < ApplicationController
  def index
    notifications = current_customer.passive_notifications.all
    @notification = notifications.where.not(visitor_id: current_customer.id).&(notifications.where.not(checked: true))
    # インデックスを開いたってことは、通知は見たってことだから、チェックをtrueにする。※良いね連発で通知が爆発することを恐れて、DBに保存したままにしている。(存在チェックで連続投稿)
    notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
end
