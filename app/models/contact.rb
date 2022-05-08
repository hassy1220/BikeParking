class Contact < ApplicationRecord
  enum subject: { others: 0, posted_content: 1, unauthorizes_user: 2}
  belongs_to:customer
end
