class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "Customer"
  belongs_to :follow, class_name: "Customer"
  # follow_id follower_id同じものは1つしか作成できない
  validates :follower_id, presence: true
  validates :follow_id, presence: true
end
