module Api
  module V1
    class ExamsController < ApplicationController
      include Paginable

      before_action :set_exams, only: [:show, :update, :destroy]

      def index
        exams = if params[:q].present?
                  Exam.ransack(params[:q]).result(distinct: true).page(current_page).per(per_page)
                else
                  Exam.page(current_page).per(per_page)
                end
        authorize exams
        render json: { exams:, meta: meta_attributes(exams) }, status: :ok
      end

      def show
        authorize @exam
        render json: { exam: @exam }, status: :ok
      end

      def create
        exam = current_user.exams.new(exam_params)
        authorize exam
        if exam.save
          render json: { exam: }, status: :ok
        else
          render json: { errors: exam.errors }, status: :unprocessable_entity
        end
      end

      def update
        authorize @exam
        if @exam.update(exam_params)
          render json: { exam: @exam }, status: :ok
        else
          render json: { errors: @exam.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @exam
        @exam.destroy
        head :no_content
      end

      private

      def set_exams
        @exam = Exam.find(params[:id])
      end

      def exam_params
        params.require(:exam).permit(:title, :school_subject_id)
      end
    end
  end
end
