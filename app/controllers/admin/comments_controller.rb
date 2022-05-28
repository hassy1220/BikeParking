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
    # redirect_to request.referer
    @park_comments = park.comments.page(params[:page]).per(5)
  end

  def show
    park = Park.find(params[:park_id])
    @park_comments = park.comments.page(params[:page]).per(5)
    respond_to do |format|
      format.html
      format.js
    end
  end

end
