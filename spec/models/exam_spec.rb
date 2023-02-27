require 'rails_helper'

RSpec.describe Exam, type: :model do
  describe 'database' do
    context 'columns' do
      it { is_expected.to have_db_column(:theme).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:status).of_type(:integer).with_options(default: 0) }
      it { is_expected.to have_db_column(:finished).of_type(:datetime) }
    end

    context 'indexes' do
      it { is_expected.to have_db_index(:subject_id) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:subject) }
    it { is_expected.to have_many(:questions) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:theme) }
  end

  describe 'create exam' do
    let(:subject) { create(:subject) }
    let(:exam) { create(:exam, subject:) }

    it 'creates exam' do
      expect(exam).to be_valid
    end
  end
end
