FactoryBot.define do
  factory :exam do
    theme { Faker::Lorem.sentence }
    status { %i[pending waiting approved rejected].sample }
    finished { nil }
    subject
  end
end
