module Api
  module V1
    class UserExamsController < ApplicationController
      before_action :set_user_exam, only: [:show, :destroy, :update]

      def index
        user_exams = current_user.user_exams.all
        render json: user_exams, status: :ok
      end

      def show
        render json: @user_exam, serializer: UserExamSerializer, show_detail: true, status: :ok
      end

      def create
        user_exam = current_user.user_exams.build(user_exam_params)
        if user_exam.save
          render json: user_exam, status: :ok
        else
          render json: { errors: user_exam.errors }, status: :unprocessable_entity
        end
      end

      def update
        answer = ProofCorrectService.new(params).call
        if answer
          render json: @user_exam, serializer: UserExamSerializer, show_detail: true, status: :ok
        else
          head :unprocessable_entity
        end
      end

      def destroy
        @user_exam.destroy
        head :no_content
      end

      private

      def set_user_exam
        @user_exam = current_user.user_exams.find(params[:id])
      end

      def user_exam_params
        params.require(:user_exam).permit(:exam_id, :score)
      end
    end
  end
end
