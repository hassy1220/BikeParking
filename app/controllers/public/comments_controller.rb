class Public::CommentsController < ApplicationController
  def create
    @park = Park.find(params[:park_id])
    comment = Comment.new(comment_params)
    comment.park_id = @park.id
    comment.customer_id = current_customer.id
    comment.save
    redirect_to public_park_path(@park.id)
  end
  private
  def comment_params
    params.require(:comment).permit(:comment)
  end
end
