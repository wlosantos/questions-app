class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :ask, :exam_id

  def attributes(*args)
    hash = super
    if @instance_options[:show_detail]
      hash[:answers] = object.answers.map do |answer|
        {
          id: answer.id,
          response: answer.response,
          corrected: answer.corrected
        }
      end
    end
    hash
  end
end
