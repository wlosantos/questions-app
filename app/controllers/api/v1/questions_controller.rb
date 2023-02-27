module Api
  module V1
    class QuestionsController < ApplicationController
      include Paginable

      before_action :set_question, only: [:show, :update, :destroy]
      before_action :set_exam, except: [:index, :update, :destroy]

      def index
        questions = if params[:q].present?
                      Question.ransack(params[:q]).result(distinct: true).page(current_page).per(per_page)
                    else
                      Question.page(current_page).per(per_page)
                    end
        authorize questions
        render json: questions, meta: meta_attributes(questions), status: :ok
      end

      def show
        authorize @question
        render json: @question, status: :ok
      end

      def create
        question = @exam.questions.new(question_params)
        authorize question
        if question.save
          render json: question, status: :ok
        else
          render json: { errors: question.errors }, status: :unprocessable_entity
        end
      end

      def update
        authorize @question
        if @question.update(question_params)
          render json: @question, status: :ok
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

      def set_exam
        @exam = Exam.find(params[:exam_id])
      end

      def question_params
        params.require(:question).permit(:ask, :exam_id)
      end
    end
  end
end
