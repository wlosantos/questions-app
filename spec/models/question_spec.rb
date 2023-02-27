require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'database' do
    context 'columns' do
      it { is_expected.to have_db_column(:ask).of_type(:string).with_options(null: false) }
    end

    context 'indexes' do
      it { is_expected.to have_db_index(:exam_id) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:exam) }
    it { is_expected.to have_many(:answers).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:ask) }
  end

  describe 'create question' do
    let(:question) { build(:question) }

    it 'creates a question' do
      expect(question).to be_valid
    end
  end
end
