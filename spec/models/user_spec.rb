require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'database' do
    context 'columns must be present' do
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:email).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:password_digest).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:username).of_type(:string).with_options(null: false) }
    end
  end

  describe 'validations' do
    let!(:user) { create(:user) }
    context 'email' do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
      it { is_expected.to allow_value('contact@email.com').for(:email) }
      it { is_expected.to_not allow_value('contact').for(:email) }
    end

    context 'username' do
      it { is_expected.to validate_presence_of(:username) }
      it { is_expected.to validate_uniqueness_of(:username) }
      it { is_expected.to validate_length_of(:username).is_at_least(3).is_at_most(20) }
    end

    context 'password' do
      it { is_expected.to validate_presence_of(:password) }
      it { is_expected.to validate_length_of(:password).is_at_least(6) }
    end
  end

  describe 'create user' do
    context 'with valid params' do
      let(:user) { build(:user) }

      it 'should create user' do
        expect(user.save).to be_truthy
      end
    end

    context 'with invalid params' do
      let(:user) { build(:user, email: 'invalid_email') }

      it 'should not create user' do
        expect(user.save).to be_falsey
      end

      it 'should return error message' do
        user.save
        expect(user.errors.full_messages).to include('Email is invalid')
      end

      it 'username not should min 3 characters' do
        user.username = 'ab'
        user.save
        expect(user.errors.full_messages).to include('Username is too short (minimum is 3 characters)')
      end

      it 'username not should max 20 characters' do
        user.username = 'a' * 21
        user.save
        expect(user.errors.full_messages).to include('Username is too long (maximum is 20 characters)')
      end

      it 'same email' do
        user.save
        user2 = build(:user, email: user.email)
        user2.save
        expect(user2.errors.full_messages.to_sentence).to match(/Email is invalid/)
      end
    end

    context 'with admin role' do
      let(:user) { create(:user, :admin) }

      it 'should create user with admin role' do
        expect(user.has_role?(:admin)).to be_truthy
      end
    end

    context 'with participant role' do
      let(:user) { create(:user, :participant) }

      it 'should create user with participant role' do
        expect(user.has_role?(:participant)).to be_truthy
      end
    end

    context 'with first user is admin' do
      let(:user) { create(:user) }

      it 'should create user with admin role' do
        expect(user.has_role?(:admin)).to be_truthy
      end
    end
  end
end
