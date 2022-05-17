class Vicinity < ApplicationRecord
  has_many:vicinity_parks,dependent: :destroy
  has_many:vicinity_park,through: :vicinity_parks,source: :park

end
