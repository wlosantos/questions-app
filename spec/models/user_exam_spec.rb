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
    it { is_expected.to have_many(:user_answers).dependent(:destroy) }
  end

  describe 'be valid user_exam' do
    let(:user) { create(:user) }
    let(:exam) { create(:exam, :approved) }
    let(:user_exam) { create(:user_exam, user:, exam:) }

    it 'should be valid' do
      expect(user_exam).to be_valid
    end
  end

  describe 'when user exam exist' do
    let(:user) { create(:user) }
    let(:exam) { create(:exam, :approved) }
    let(:user_exam) { create(:user_exam, user:, exam:) }

    it 'should be invalid' do
      expect(user_exam).to be_valid
      expect { create(:user_exam, user:, exam:) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
