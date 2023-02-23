require 'rails_helper'

RSpec.describe "Api::V1::Sessions", type: :request do
  before { host! 'api.questions-api.io' }

  describe 'POST /sessions' do
    let(:user) { create(:user, :admin) }

    context 'when the credentials are correct' do
      before do
        post '/sessions', params: { email: user.email, password: user.password }
      end

      let(:token) { JSON.parse(response.body)['token'] }

      it 'returns a JWT token' do
        expect(token).not_to be_falsey
      end

      it 'authenticates user with JWT token' do
        get '/users', headers: { 'Authorization' => "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the credentials are incorrect' do
      before do
        post '/sessions', params: { email: user.email, password: 'wrong_password' }
      end

      it 'returns a JWT token' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error message' do
        expect(response.body).to match(/Invalid credentials/)
      end
    end
  end
end
