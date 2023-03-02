require 'rails_helper'

RSpec.describe UserAnswer, type: :model do
  describe 'database' do
    it { is_expected.to have_db_column(:question_ref).of_type(:integer) }
    it { is_expected.to have_db_column(:answer).of_type(:integer) }
    it { is_expected.to have_db_column(:trusty).of_type(:boolean) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user_exam) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:question_ref) }
    it { is_expected.to validate_presence_of(:answer) }
  end
end
