FactoryBot.define do
  factory :question do
    description { Faker::Lorem.paragraph }
    status { %i[blocked active].sample }
    value { rand(0...10) }
    exam
    user
  end
end
