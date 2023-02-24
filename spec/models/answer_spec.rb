require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'database' do
    context 'must be present' do
      it { should have_db_column(:description).of_type(:string).with_options(null: false) }
      it { should have_db_column(:correct).of_type(:boolean).with_options(null: false, default: false) }
    end
  end

  describe 'associations' do
    it { should belong_to(:question) }
  end

  describe 'validations' do
    it { should validate_presence_of(:description) }
  end

  describe 'create answer' do
    context 'successfull' do
      let(:answer) { build(:answer) }

      it 'creates a answer' do
        expect(answer).to be_valid
      end
    end

    context 'failure' do
      let(:answer) { build(:answer, correct: nil) }

      it 'does not create a answer' do
        expect(answer).to_not be_valid
      end
    end
  end
end
