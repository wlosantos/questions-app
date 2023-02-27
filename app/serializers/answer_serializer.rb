class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :response, :corrected, :question_id
end
