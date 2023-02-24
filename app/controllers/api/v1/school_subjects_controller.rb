module Api
  module V1
    class SchoolSubjectsController < ApplicationController
      before_action :set_school_subject, only: [:update, :destroy]
      def index
        school_subjects = SchoolSubject.all
        authorize school_subjects
        render json: { school_subjects: }, status: :ok
      end

      def create
        school_subject = SchoolSubject.new(school_subject_params)
        if school_subject.save
          render json: { school_subject: }, status: :ok
        else
          render json: { errors: school_subject.errors }, status: :unprocessable_entity
        end
      end

      def update
        authorize @school_subject
        if @school_subject.update(school_subject_params)
          render json: { school_subject: @school_subject }, status: :ok
        else
          render json: { errors: @school_subject.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @school_subject.destroy
        head 204
      end

      private

      def set_school_subject
        @school_subject = SchoolSubject.find(params[:id])
      end

      def school_subject_params
        params.require(:school_subject).permit(:name)
      end
    end
  end
end
