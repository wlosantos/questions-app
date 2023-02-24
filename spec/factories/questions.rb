FactoryBot.define do
  factory :question do
    description { Faker::Lorem.paragraph }
    status { Status.list.sample }
    value { rand(0...10) }
    exam
    user
  end
end
