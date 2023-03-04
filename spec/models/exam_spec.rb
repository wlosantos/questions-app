require 'rails_helper'

RSpec.describe Exam, type: :model do
  describe 'database' do
    context 'columns' do
      it { is_expected.to have_db_column(:theme).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:status).of_type(:integer) }
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

    context 'when is valid' do
      it { expect(exam).to be_valid }
    end

    context 'when is invalid' do
      let(:exam) { build(:exam, theme: nil) }

      it { expect(exam).to be_invalid }
    end

    context 'when is finished' do
      let(:exam) { create(:exam, finished: Time.now) }

      it { expect(exam.finished?).to be_truthy }
    end
  end
end
