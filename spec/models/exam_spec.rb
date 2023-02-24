require 'rails_helper'

RSpec.describe Exam, type: :model do
  describe 'database' do
    context 'columns' do
      it { is_expected.to have_db_column(:title).of_type(:string).with_options(null: false) }
    end

    context 'indexes' do
      it { is_expected.to have_db_index(:school_subject_id) }
      it { is_expected.to have_db_index(:user_id) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:school_subject) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'create exam' do
    let(:user) { create(:user) }
    let(:school_subject) { create(:school_subject) }
    let(:exam) { create(:exam, user:, school_subject:) }

    it 'creates exam' do
      expect(exam).to be_valid
    end
  end
end
