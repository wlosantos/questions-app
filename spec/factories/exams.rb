FactoryBot.define do
  factory :exam do
    title { Faker::Lorem.sentence }
    school_subject
    user
  end
end
