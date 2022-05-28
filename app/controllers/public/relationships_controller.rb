class Public::RelationshipsController < ApplicationController
  def create
    @customer = Customer.find(params[:customer_id])
    relationship = Relationship.new
    relationship.follow_id = current_customer.id
    relationship.follower_id = @customer.id
    relationship.save
    @customer.create_notification_follow!(current_customer)
    @customers = Customer.where(is_deleted: false)
    @follow_customer = current_customer
    @follower_customer = current_customer
    @search = params[:list]

    if @search.presence
      @customers = Customer.where(is_deleted: false).where('name LIKE ?', "%#{@search}%")
    end
  end

  def destroy
    @customer = Customer.find(params[:customer_id])
    relationship = Relationship.find_by(follow_id: current_customer.id, follower_id: @customer.id)
    relationship.destroy
    @customers = Customer.where(is_deleted: false)
    @follow_customer = current_customer
    @follower_customer = current_customer
    @search = params[:list]

    if @search.presence
      @customers = Customer.where(is_deleted: false).where('name LIKE ?', "%#{@search}%")
    end
  end

  def show
    @key = params[:key]
    @customer = Customer.find(params[:customer_id])
    @follow_customer = @customer.follow_user
    @follower_customer = @customer.follower_user
  end
end
