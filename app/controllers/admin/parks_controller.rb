class Admin::ParksController < ApplicationController
  def index
    @parks = Park.page(params[:page]).per(8)
  end

  def show
    @park = Park.find(params[:id])
    @park_comments = @park.comments.page(params[:page]).per(5)
  end

  def destroy
    park = Park.find(params[:id])
    park.destroy
    redirect_to admin_parks_path
  end
end
