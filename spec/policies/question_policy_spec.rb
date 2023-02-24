require 'rails_helper'

RSpec.describe QuestionPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user:) }
  subject { described_class }

  permissions :index? do
    it 'denies access if user is not an admin' do
      expect(subject).not_to permit(user)
    end

    it 'grants access if user is an admin' do
      user.add_role :admin
      expect(subject).to permit(user)
    end
  end

  permissions :show? do
    it 'denies access if user is not an admin' do
      expect(subject).not_to permit(user)
    end

    it 'grants access if user is an admin' do
      user.add_role :admin
      expect(subject).to permit(user)
    end
  end

  permissions :create? do
    it 'grants access if user is an admin' do
      user.add_role :admin
      expect(subject).to permit(user)
    end

    it 'denies access if user is not an admin' do
      expect(subject).not_to permit(user)
    end
  end

  permissions :update? do
    it 'grants access if user is an admin' do
      user.add_role :admin
      expect(subject).to permit(user)
    end

    it 'grants access if user is the same as the record' do
      expect(subject).to permit(user, question)
    end

    it 'denies access if user is not an admin and not the same as the record' do
      expect(subject).not_to permit(user2, question)
    end
  end

  permissions :destroy? do
    it 'grants access if user is an admin' do
      user.add_role :admin
      expect(subject).to permit(user)
    end

    it 'grants access if user is the same as the record' do
      expect(subject).to permit(user, question)
    end

    it 'denies access if user is not an admin and not the same as the record' do
      expect(subject).not_to permit(user2, question)
    end
  end
end
