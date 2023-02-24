class QuestionPolicy < ApplicationPolicy
  def index?
    permissions?
  end

  def show?
    permissions?
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