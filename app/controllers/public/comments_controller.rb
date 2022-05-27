class Public::CommentsController < ApplicationController
  def create
    @park = Park.find(params[:park_id])
    @comment = Comment.new(comment_params)
    @comment.park_id = @park.id
    @comment.customer_id = current_customer.id
    if @comment.save
      # park.rbのcreate_notification_comment!(current_customer, comment_id)メソッドを実行
      @park.create_notification_comment!(current_customer, @comment.id)
      if @park.customer.is_deleted == false
        # app/mailers/comment_mailer.rb内のsend_commentメソッドに内容を送信
        CommentMailer.with(customer: @park.customer.id, park: @park.id).send_comment.deliver_now
      end
      @park_comment = Comment.new
    else
      flash.now[:danger] = @comment.errors.full_messages
    end
    @park_comments = @park.comments.page(params[:page]).per(5)

  end

  def destroy
    # ダブルクリック回避方法
    @park = Park.find(params[:park_id])
    comment = params[:id]
    park_comment = @park.comments.ids
    if park_comment.include?(comment.to_i)
      # debugger
      comment = Comment.find(comment)
      comment.destroy
    end
    @park_comment = Comment.new
    @park_comments = @park.comments.page(params[:page]).per(5)

    # redirect_to request.referer
  end

  def index
    @park_comment = Comment.new
    @park = Park.find(params[:park_id])
    @park_comments = @park.comments.page(params[:page]).per(5)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @park_comment = Comment.new
    @park = Park.find(params[:park_id])
    @park_comments = @park.comments.page(params[:page]).per(5)
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
