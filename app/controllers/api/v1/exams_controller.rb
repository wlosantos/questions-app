module Api
  module V1
    class ExamsController < ApplicationController
      before_action :set_exams, only: [:show, :update, :destroy]

      def index
        exams = Exam.all
        render json: { exams: }, status: :ok
      end

      def show
        render json: { exam: @exam }, status: :ok
      end

      def create
        exam = current_user.exams.new(exam_params)
        if exam.save
          render json: { exam: }, status: :ok
        else
          render json: { errors: exam.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @exam.update(exam_params)
          render json: { exam: @exam }, status: :ok
        else
          render json: { errors: @exam.errors }, status: :unprocessable_entity
        end
      end

      def destroy
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
