FactoryGirl.define do
  factory :user do
    transient do
      sequence (:name) { |n| "user#{n}" }
    end

    email { "#{name}@test.dev" }
    password 'testpassword'
    confirmed_at { 3.days.ago }

    [:vkontakte, :facebook, :google_oauth2].each do |provider|
      trait provider do
        after :create do |user|
          create :authentication, provider: provider, user: user
        end
      end
    end

    trait :admin do
      # admin true
    end
  end
end
