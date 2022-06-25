class Public::CommentsController < ApplicationController
  def create
    @park = Park.find(params[:park_id])
    @comment = Comment.new(comment_params)
    @comment.park_id = @park.id
    @comment.customer_id = current_customer.id
    if @comment.save
      # park.rbのcreate_notification_comment!(current_customer, comment_id)メソッドを実行
      @park.create_notification_comment!(current_customer, @comment.id)
       # もし、駐輪場投稿者が退会済であればメールは送らない。
      if @park.customer.is_deleted == false
        # app/mailers/comment_mailer.rb内のsend_commentメソッドに内容を送信
        CommentMailer.with(customer: @park.customer.id, park: @park.id).send_comment.deliver_now
      end
      @park_comment = Comment.new
    else
      render :error
    end
    @park_comments = @park.comments.page(params[:page]).per(5)
    # create.js.erbを探しに行く
  end

  def destroy
    # ダブルクリック回避方法
    @park = Park.find(params[:park_id])
    comment = params[:id]
    park_comment = @park.comments.ids
    if park_comment.include?(comment.to_i)
      comment = Comment.find(comment)
      comment.destroy
    end
    @park_comment = Comment.new
    @park_comments = @park.comments.page(params[:page]).per(5)


  end

  # コメント成功後、ページネーションも非同期で呼び出したすぐに、ページネーションにて画面を切り替えるために必要。
  def index
    @park_comment = Comment.new
    @park = Park.find(params[:park_id])
    @park_comments = @park.comments.page(params[:page]).per(5)
    respond_to do |format|
      format.html
      format.js
    end
    # index.js.erbを探しに
  end

  # コメント削除にてページネーションも非同期で呼び出したすぐに、ページネーションにて画面を切り替えるために必要。
  def show
    @park_comment = Comment.new
    @park = Park.find(params[:park_id])
    @park_comments = @park.comments.page(params[:page]).per(5)
    respond_to do |format|
      format.html
      format.js
    end
    # show.js.erbを探しに
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
