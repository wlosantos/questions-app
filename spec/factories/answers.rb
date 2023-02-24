FactoryBot.define do
  factory :answer do
    description { Faker::Lorem.sentence(word_count: 3) }
    correct { [false, true].sample }
    question
  end
end
