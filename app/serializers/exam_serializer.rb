class ExamSerializer < ActiveModel::Serializer
  attributes :id, :theme, :subject, :created, :finished

  def subject
    object.subject.name
  end

  def created
    object.created_at.strftime('%d/%m/%Y')
  end
end
