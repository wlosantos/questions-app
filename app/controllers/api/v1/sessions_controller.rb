module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :autenticate!, only: :create

      def create
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          token = JwtAuth::TokenProvider.issue_token({ email: user.email })
          render json: { token: }, status: :ok
        else
          render json: { error: 'Invalid credentials' }, status: :unauthorized
        end
      end
    end
  end
end
