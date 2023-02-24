class UserPolicy < ApplicationPolicy
  def index?
    permissions?
  end

  def show?
    permissions? || user == record
  end

  def update?
    permissions? || user == record
  end

  def destroy?
    permissions? || user == record
  end
end
