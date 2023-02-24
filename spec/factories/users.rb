FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    username { Faker::Internet.username(specifier: 5) }
    password { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }

    trait :admin do
      after(:create) do |user|
        user.add_role(:admin)
      end
    end

    trait :participant do
      after(:create) do |user|
        user.add_role(:participant)
      end
    end
  end
end
