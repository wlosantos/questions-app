FactoryBot.define do
  factory :answer do
    response { Faker::Lorem.sentence(word_count: 3) }
    corrected { false }
    question
  end
end
