class Contact < ApplicationRecord
  enum subject: { others: 0, posted_content: 1, unauthorizes_user: 2 }
  validates :name,presence: true
  validates :email,presence: true
  validates :phone_number,presence: true
  validates :message,presence: true
end
