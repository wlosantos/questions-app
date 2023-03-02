class ProofCorrectService < ApplicationService
  def initialize(params)
    @params = params
    @user_exam = UserExam.find_by(id: params['id'].to_i)
    @score = 0
  end

  def call
    persisted_data
  end

  private

  def persisted_data
    result = @params['user_answer'].each do |answer|
      user_answer = @user_exam.user_answers.find_by(question_ref: answer['question'].to_i)
      @score += set_score if correct?(answer['answer'].to_i)

      return false unless user_answer

      user_answer.update(answer: answer['answer'].to_i, trusty: correct?(answer['answer'].to_i))
    end

    @user_exam.update(score: @score)
    result
  end

  def correct?(answer)
    Answer.find(answer).corrected == true
  end

  def set_score
    10 / @user_exam.exam.questions.size
  end
end
