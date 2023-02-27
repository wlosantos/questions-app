module Api
  module V1
    class SubjectsController < ApplicationController
      include Paginable

      before_action :set_subject, only: [:update, :destroy]
      def index
        subjects = Subject.page(current_page).per(per_page)
        authorize subjects
        render json: { subjects:, meta: meta_attributes(subjects) }, status: :ok
      end

      def create
        subject = Subject.new(subject_params)
        if subject.save
          render json: { subject: }, status: :ok
        else
          render json: { errors: subject.errors }, status: :unprocessable_entity
        end
      end

      def update
        authorize @subject
        if @subject.update(subject_params)
          render json: { subject: @subject }, status: :ok
        else
          render json: { errors: @subject.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @subject.destroy
        head 204
      end

      private

      def set_subject
        @subject = Subject.find(params[:id])
      end

      def subject_params
        params.require(:subject).permit(:name)
      end
    end
  end
end
