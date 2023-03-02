require 'rails_helper'

RSpec.describe Subject, type: :model do
  describe 'database' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(30) }
  end

  describe 'create a school subject' do
    let(:subject) { build(:subject) }

    it 'creates a school subject' do
      expect(subject).to be_valid
    end
  end
end
