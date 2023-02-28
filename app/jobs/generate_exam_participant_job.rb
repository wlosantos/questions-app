class GenerateExamParticipantJob < ApplicationJob
  queue_as :default

  def perform(user_exam)
    user_exam.exam.questions.includes(:answers).each do |question|
      question.answers.each do |answer|
        UserAnswer.create(user_exam:, question_ref: question.id, answer: answer.id)
      end
    end
  end
end
