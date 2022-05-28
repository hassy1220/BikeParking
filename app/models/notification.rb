class Notification < ApplicationRecord
  belongs_to :park, optional: true
  belongs_to :comment, optional: true

  belongs_to :visitor, class_name: 'Customer', optional: true
  belongs_to :visited, class_name: 'Customer', optional: true
end
