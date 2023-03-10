module Api
  module V1
    class AnswersController < ApplicationController
      include Paginable

      before_action :set_question, only: [:create]
      before_action :set_answer, only: [:show, :update, :destroy]

      def index
        answers = if params[:q].present?
                    Answer.ransack(params[:q]).result(distinct: true).page(current_page).per(per_page)
                  else
                    Answer.page(current_page).per(per_page)
                  end
        authorize answers
        render json: answers, meta: meta_attributes(answers), status: :ok
      end

      def show
        authorize @answer
        render json: @answer, status: :ok
      end

      def create
        @answer = @question.answers.new(answer_params)
        authorize @answer
        if @answer.save
          render json: @answer, status: :ok
        else
          render json: { errors: @answer.errors }, status: :unprocessable_entity
        end
      end

      def update
        authorize @answer
        if @answer.update(answer_params)
          render json: @answer, status: :ok
        else
          render json: { errors: @answer.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @answer
        @answer.destroy
        head :no_content
      end

      private

      def set_answer
        @answer = Answer.find(params[:id])
      end

      def set_question
        @question = Question.find(params[:question_id])
      end

      def answer_params
        params.require(:answer).permit(:response, :corrected)
      end
    end
  end
end
