require 'rails_helper'

RSpec.describe AnswerPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user:) }
  let(:answer) { create(:answer, question:) }

  subject { described_class }

  permissions :index? do
    it 'grants access if user is an admin' do
      user.add_role :admin
      expect(subject).to permit(user)
    end

    it 'grants access if user is the same as the record' do
      expect(subject).to permit(user, answer.question)
    end

    it 'denies access if user is not an admin and not the same as the record' do
      expect(subject).not_to permit(user2, answer.question)
    end
  end

  permissions :show? do
    it 'grants access if user is an admin' do
      user.add_role :admin
      expect(subject).to permit(user)
    end

    it 'grants access if user is the same as the record' do
      expect(subject).to permit(user, answer.question)
    end

    it 'denies access if user is not an admin and not the same as the record' do
      expect(subject).not_to permit(user2, answer.question)
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
      expect(subject).to permit(user, answer.question)
    end

    it 'denies access if user is not an admin and not the same as the record' do
      expect(subject).not_to permit(user2, answer.question)
    end
  end

  permissions :destroy? do
    it 'grants access if user is an admin' do
      user.add_role :admin
      expect(subject).to permit(user)
    end

    it 'grants access if user is the same as the record' do
      expect(subject).to permit(user, answer.question)
    end

    it 'denies access if user is not an admin and not the same as the record' do
      expect(subject).not_to permit(user2, answer.question)
    end
  end
end
