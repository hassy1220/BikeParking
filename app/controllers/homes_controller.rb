class HomesController < ApplicationController
  def top
    @customer = Customer.where('id >= ?', rand(Customer.first.id..Customer.last.id)).first
  end
end
