require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  before { host! 'api.questions-api.io' }
  let!(:user) { create(:user, name: 'Wendel Lopes', username: 'wendellopes') }
  let!(:token) { JwtAuth::TokenProvider.issue_token({ email: user.email }) }
  let(:headers) do
    {
      'Accept' => 'application/vnd.questions-api.v1',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => "Bearer #{token}"
    }
  end

  describe 'GET /users' do
    before { get '/users', params: {}, headers: }

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns all users' do
      expect(json_body[:users].count).to eq(1)
    end
  end

  describe 'GET /users/:id' do
    before { get "/users/#{user.id}", params: {}, headers: }

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the user' do
      expect(json_body[:user][:id]).to eq(user.id)
    end
  end

  describe 'PUT /users/:id' do
    before { put "/users/#{user.id}", params: user_params.to_json, headers: }

    context 'when the request params are valid' do
      let(:user_params) { { user: { name: 'Cristiano Ronaldo', password: user.password } } }

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the updated user' do
        expect(json_body[:user][:name]).to eq(user_params[:user][:name])
      end
    end
  end

  describe 'DELETE /users/:id' do
    before { delete "/users/#{user.id}", params: {}, headers: }

    it 'returns success status' do
      expect(response).to have_http_status(:no_content)
    end

    it 'removes the user from database' do
      expect(User.find_by(id: user.id)).to be_nil
    end
  end
end
