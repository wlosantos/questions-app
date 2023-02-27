FactoryBot.define do
  factory :question do
    ask { Faker::Lorem.paragraph }
    exam
  end
end
