FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    username { name.split(' ')[0] }
    password { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }
  end
end
