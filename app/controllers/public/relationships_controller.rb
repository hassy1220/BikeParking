class Public::RelationshipsController < ApplicationController
  def create
    @customer = Customer.find(params[:customer_id])
    relationship = Relationship.new
    relationship.follow_id = current_customer.id
    relationship.follower_id = @customer.id
    relationship.save
    @customer.create_notification_follow!(current_customer)
    redirect_to request.referer
  end
  def destroy
    customer = Customer.find(params[:customer_id])
    relationship = Relationship.find_by(follow_id: current_customer.id,follower_id: customer.id)
    relationship.destroy
    redirect_to request.referer
  end

  def show
    @key = params[:key]
    customer = Customer.find(params[:customer_id])
    @follow_customer = customer.relationships
    @follower_customer = customer.reverse_of_relationships
  end
end
