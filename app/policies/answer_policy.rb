class AnswerPolicy < ApplicationPolicy
  def index?
    permissions? || user == record.user
  end

  def show?
    permissions? || user == record.user
  end

  def create?
    permissions?
  end

  def update?
    permissions? || user == record.user
  end

  def destroy?
    permissions? || user == record.user
  end
end
