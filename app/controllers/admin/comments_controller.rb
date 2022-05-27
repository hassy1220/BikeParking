class Admin::CommentsController < ApplicationController
  def destroy
    park = Park.find(params[:park_id])
    comment = params[:id]
    park_comment = park.comments.ids
    if park_comment.include?(comment.to_i)
      # debugger
      comment = Comment.find(comment)
      comment.destroy
    end
    redirect_to request.referer
  end
end
