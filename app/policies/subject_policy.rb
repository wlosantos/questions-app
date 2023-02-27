class SubjectPolicy < ApplicationPolicy
  def index?
    permissions?
  end

  def create?
    permissions?
  end

  def update?
    permissions?
  end

  def destroy?
    permissions?
  end
end
