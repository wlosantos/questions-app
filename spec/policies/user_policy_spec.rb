require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  let(:user) { create(:user) }

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
    it 'grants access if user is an admin' do
      user.add_role :admin
      expect(subject).to permit(user)
    end

    it 'grants access if user is the same as the record' do
      expect(subject).to permit(user, user)
    end

    it 'denies access if user is not an admin and not the same as the record' do
      expect(subject).not_to permit(user)
    end
  end

  permissions :update? do
    it 'grants access if user is an admin' do
      user.add_role :admin
      expect(subject).to permit(user)
    end

    it 'grants access if user is the same as the record' do
      expect(subject).to permit(user, user)
    end

    it 'denies access if user is not an admin and not the same as the record' do
      expect(subject).not_to permit(user)
    end
  end

  permissions :destroy? do
    it 'grants access if user is an admin' do
      user.add_role :admin
      expect(subject).to permit(user)
    end

    it 'grants access if user is the same as the record' do
      expect(subject).to permit(user, user)
    end

    it 'denies access if user is not an admin' do
      expect(subject).not_to permit(user)
    end
  end
end
