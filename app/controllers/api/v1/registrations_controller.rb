module Api
  module V1
    class RegistrationsController < ApplicationController
      def create
        user = User.new(user_params)
        if user.save
          render json: { success: 'Welcome! You have signed up successfully.' }, status: :created
        else
          render json: { errors: user.errors }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :username, :password, :password_confirmation)
      end
    end
  end
end
