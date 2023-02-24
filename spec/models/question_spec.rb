require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'database' do
    context 'columns' do
      it { is_expected.to have_db_column(:description).of_type(:text).with_options(null: false) }
      it { is_expected.to have_db_column(:status).of_type(:integer).with_options(null: false) }
      it { is_expected.to have_db_column(:value).of_type(:integer).with_options(null: false) }
    end

    context 'indexes' do
      it { is_expected.to have_db_index(:exam_id) }
      it { is_expected.to have_db_index(:user_id) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:exam) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_numericality_of(:value).only_integer.is_greater_than_or_equal_to(0) }
  end

  describe 'create question' do
    let(:question) { build(:question) }

    it 'creates a question' do
      expect(question).to be_valid
    end
  end
end
