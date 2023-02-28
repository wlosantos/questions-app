require 'rails_helper'

RSpec.describe UserExam, type: :model do
  describe 'database' do
    context 'must be present' do
      it { should have_db_column(:user_id).of_type(:integer) }
      it { should have_db_column(:exam_id).of_type(:integer) }
      it { should have_db_column(:score).of_type(:float) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:exam) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:score) }
    it { is_expected.to validate_numericality_of(:score).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:score).is_less_than_or_equal_to(10) }
  end

  describe 'be valid user_exam' do
    let(:user) { create(:user) }
    let(:exam) { create(:exam) }
    let(:user_exam) { create(:user_exam, user:, exam:) }

    it 'should be valid' do
      expect(user_exam).to be_valid
    end
  end
end
