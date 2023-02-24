module Api
  module V1
    class QuestionsController < ApplicationController
      before_action :set_question, only: [:show, :update, :destroy]

      def index
        questions = Question.all
        render json: { questions: }, status: :ok
      end

      def show
        render json: { question: @question }, status: :ok
      end

      def create
        question = current_user.questions.build(question_params)
        if question.save
          render json: { question: }, status: :ok
        else
          render json: { errors: question.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @question.update(question_params)
          render json: { question: @question }, status: :ok
        else
          render json: { errors: @question.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @question.destroy
        head :no_content
      end

      private

      def set_question
        @question = Question.find(params[:id])
      end

      def question_params
        params.require(:question).permit(:title, :description, :status, :exam_id, :value)
      end
    end
  end
end
