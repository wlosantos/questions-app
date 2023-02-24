module Api
  module V1
    class AnswersController < ApplicationController
      before_action :set_question
      before_action :set_answer, only: [:show, :update, :destroy]

      def index
        @answers = @question.answers
        render json: { answers: @answers }, status: :ok
      end

      def show
        render json: { answer: @answer }, status: :ok
      end

      def create
        @answer = @question.answers.new(answer_params)
        if @answer.save
          render json: { answer: @answer }, status: :ok
        else
          render json: { errors: @answer.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @answer.update(answer_params)
          render json: { answer: @answer }, status: :ok
        else
          render json: { errors: @answer.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @answer.destroy
        head :no_content
      end

      private

      def set_answer
        @answer = @question.answers.find(params[:id])
      end

      def set_question
        @question = Question.find(params[:question_id])
      end

      def answer_params
        params.require(:answer).permit(:description, :correct)
      end
    end
  end
end
