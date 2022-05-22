class Public::CommentsController < ApplicationController
  def create
    # @new_comment = Comment.new
    @park = Park.find(params[:park_id])
    @comment = Comment.new(comment_params)
    @comment.park_id = @park.id
    @comment.customer_id = current_customer.id
    @park_comments = @park.comments.page(params[:page]).per(5)
    if @comment.save
      # park.rbのcreate_notification_comment!(current_customer, comment_id)メソッドを実行
       @park.create_notification_comment!(current_customer, @comment.id)
       if @park.customer.is_deleted == false
         # app/mailers/comment_mailer.rb内のsend_commentメソッドに内容を送信
         CommentMailer.with(customer: @park.customer.id,park: @park.id).send_comment.deliver_now
         @park_comment = Comment.new
       end
    else
      flash.now[:danger]=@comment.errors.full_messages
    end
  end
  private
  def comment_params
    params.require(:comment).permit(:comment)
  end
end
