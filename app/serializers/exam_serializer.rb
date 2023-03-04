class ExamSerializer < ActiveModel::Serializer
  attributes :id, :theme, :subject, :status, :created, :finished

  def subject
    object.subject.name
  end

  def created
    object.created_at.strftime('%d/%m/%Y')
  end

  def attributes(*args)
    hash = super
    if @instance_options[:show_detail]
      hash[:questions] = object.questions.includes(:answers).all.map do |question|
        {
          id: question.id,
          ask: question.ask,
          answers: question.answers.map do |answer|
            {
              id: answer.id,
              response: answer.response,
              corrected: answer.corrected
            }
          end
        }
      end
    end
    hash
  end
end
