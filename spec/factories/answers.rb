FactoryBot.define do
  factory :answer do
    description { Faker::Lorem.sentence(word_count: 3) }
    correct { false }
    question
  end
end
