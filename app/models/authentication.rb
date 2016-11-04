class Authentication < ApplicationRecord
  belongs_to :user, required: true
  validates :uid, :provider, presence: true
  validates :uid, uniqueness: { scope: :provider }
end
