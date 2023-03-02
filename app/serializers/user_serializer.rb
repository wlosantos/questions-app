class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :username, :role

  def role
    object.roles.map(&:name).join(', ')
  end
end
