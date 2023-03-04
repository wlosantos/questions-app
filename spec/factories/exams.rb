FactoryBot.define do
  factory :exam do
    theme { Faker::Lorem.sentence }
    status { %i[pending waiting rejected].sample }
    finished { nil }
    subject

    trait :approved do
      status { :approved }
    end
  end
end
