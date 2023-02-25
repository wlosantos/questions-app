module Api
  module V1
    class QuestionsController < ApplicationController
      include Paginable

      before_action :set_question, only: [:show, :update, :destroy]

      def index
        questions = if params[:q].present?
                      Question.ransack(params[:q]).result(distinct: true).page(current_page).per(per_page)
                    else
                      Question.page(current_page).per(per_page)
                    end
        authorize questions
        render json: { questions:, meta: meta_attributes(questions) }, status: :ok # add adapter: :json with serializer
      end

      def show
        authorize @question
        render json: { question: @question }, status: :ok
      end

      def create
        question = current_user.questions.build(question_params)
        authorize question
        if question.save
          render json: { question: }, status: :ok
        else
          render json: { errors: question.errors }, status: :unprocessable_entity
        end
      end

      def update
        authorize @question
        if @question.update(question_params)
          render json: { question: @question }, status: :ok
        else
          render json: { errors: @question.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @question
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
