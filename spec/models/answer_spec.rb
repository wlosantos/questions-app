require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'database' do
    context 'must be present' do
      it { is_expected.to have_db_column(:response).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:corrected).of_type(:boolean).with_options(null: false, default: false) }
    end

    context 'indexes' do
      it { is_expected.to have_db_index(:question_id) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:question) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:response) }
  end

  describe 'create answer' do
    context 'successfull' do
      let(:answer) { build(:answer) }

      it 'creates a answer' do
        expect(answer).to be_valid
      end
    end

    context 'failure' do
      let(:answer) { build(:answer, corrected: nil) }

      it 'does not create a answer' do
        expect(answer).to_not be_valid
      end
    end
  end
end
