FactoryGirl.define do
  factory :authentication do
    user { create :user }
    sequence (:uid) { |n| "uid#{n}" }

    trait(:fb) { provider 'facebook' }
    trait(:vk) { provider 'vkontakte' }
    trait(:go) { provider 'google_oauth2' }
  end
end
