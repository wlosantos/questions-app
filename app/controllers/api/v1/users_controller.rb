module Api
  module V1
    class UsersController < ApplicationController
      include Paginable

      before_action :set_user, only: [:show, :update, :destroy]

      def index
        users = if params[:q].present?
                  User.ransack(params[:q]).result(distinct: true).page(current_page).per(per_page)
                else
                  User.page(current_page).per(per_page)
                end
        authorize users
        render json: users, meta: meta_attributes(users), status: :ok
      end

      def show
        authorize @user
        render json: @user, status: :ok
      end

      def update
        authorize @user
        if @user.update(user_params)
          render json: @user, status: :ok
        else
          render json: { errors: @user.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @user
        @user.destroy
        head 204
      end

      def change_role_admin
        authorize current_user
        user = User.find_by(id: params[:user_id])
        if user.present? && user != User.first
          user.send_change_role
          head 204
        else
          render json: { errors: 'User not found' }, status: :not_found
        end
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
