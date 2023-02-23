module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:show, :update, :destroy]

      def index
        users = policy_scope(User.all)
        authorize users
        render json: { users: }, status: :ok
      end

      def show
        render json: { user: @user }, status: :ok
      end

      def update
        if @user.update(user_params)
          render json: { user: @user }, status: :ok
        else
          render json: { errors: @user.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @user.destroy
        head 204
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:name, :email, :username, :password, :password_confirmation)
      end
    end
  end
end
