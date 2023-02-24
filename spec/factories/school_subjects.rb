FactoryBot.define do
  factory :school_subject do
    name { Faker::Educator.subject }
  end
end
