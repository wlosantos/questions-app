FactoryBot.define do
  factory :exam do
    theme { Faker::Lorem.sentence }
    status { %i[pending waiting rejected].sample }
    finished { nil }
    blocked { false }
    subject

    trait :approved do
      status { :approved }
    end

    trait :blocked do
      blocked { true }
    end
  end
end
