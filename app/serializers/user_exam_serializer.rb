class UserExamSerializer < ActiveModel::Serializer
  attributes :id, :exam_id, :theme, :score

  def theme
    object&.exam&.theme
  end

  def attributes(*args)
    hash = super
    if @instance_options[:show_detail]
      hash[:user_answers] = object.user_answers.map do |user_answer|
        answer = Answer.find(user_answer.answer)
        {
          id: user_answer.id,
          question: user_answer.question_ref,
          answer: user_answer.answer,
          option: answer.response,
          response: user_answer.trusty
        }
      end
    end
    hash
  end
end
