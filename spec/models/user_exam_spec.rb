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
    let!(:participant) { create(:user) }
    let!(:exam) { create(:exam, :approved) }
    let(:user_exam) { build(:user_exam, user: participant, exam:) }

    it 'should be valid' do
      expect(user_exam).to be_valid
    end
  end

  describe 'create user_exam' do
    context 'successfully' do
      let!(:participant) { create(:user) }
      let!(:exam) { create(:exam, :approved) }
      let(:user_exam) { create(:user_exam, user: participant, exam:) }

      it 'should be valid' do
        expect(user_exam).to be_valid
      end
    end

    context 'when exam not is approved' do
      let!(:participant) { create(:user) }
      let!(:exam) { create(:exam) }
      let(:user_exam) { build(:user_exam, user: participant, exam:) }

      it 'should be invalid' do
        expect(user_exam).to be_invalid
      end
    end
  end
end
