FactoryGirl.define do
  factory :user do
    transient do
      sequence (:name) { |n| "user#{n}" }
    end

    email { "#{name}@test.dev" }
    password 'testpassword'
    confirmed_at { 3.days.ago }

    trait :fb do
      after :create do |user|
        create :authentication, :fb, user: user
      end
    end

    trait :admin do
      # admin true
    end
  end
end
