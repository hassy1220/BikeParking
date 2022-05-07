class Admin::ParksController < ApplicationController
  def index
    @parks = Park.all
  end
  def show
    @park = Park.find(params[:id])
    @park_comments = @park.comments.page(params[:page]).per(5)
  end
  def delete
    park = Park.find(params[:id])
    park.destroy
    redirect_to admin_parks_path
  end
end
