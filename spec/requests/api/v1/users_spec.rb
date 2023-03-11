require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  before { host! 'question-api-arbon.ondigitalocean.app' }
  let!(:admin) { create(:user, :admin) }
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
    context 'when user is admin' do
      before do
        user.add_role :admin
        get '/users', params: {}, headers:
      end

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns all users' do
        expect(json_body[:data].size).to eq(2)
      end
    end

    context 'when user is not admin' do
      before do
        get '/users', params: {}, headers:
      end

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error message' do
        expect(json_body[:error]).to eq('No Authorization!')
      end
    end

    context 'when filter params are sent' do
      let(:user1) { create(:user, name: 'Wendel Santos', username: 'wendellopes') }
      let(:user2) { create(:user, name: 'Nadia Santos', username: 'nadianunes') }

      before do
        user.add_role :admin
        get '/users?q[name_cont]=Wendel&q[s]=name+ASC', params: {}, headers:
      end

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the filtered users' do
        expect(json_body[:data].count).to eq(1)
      end
    end
  end

  describe 'GET /users/:id' do
    before { get "/users/#{user.id}", params: {}, headers: }

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the user' do
      expect(json_body[:data][:id].to_i).to eq(user.id)
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
        expect(json_body[:data][:attributes][:name]).to eq(user_params[:user][:name])
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

  describe 'POST /users/change_role_admin' do
    context 'change role to admin' do
      let!(:participant) { create(:user, :participant) }
      before do
        user.add_role :admin
        post '/users/change_role_admin', params: { user_id: participant.id }.to_json, headers:
      end

      it 'returns success status' do
        expect(response).to have_http_status(:no_content)
      end

      it 'changes the user role to admin' do
        expect(participant.reload.has_role?(:admin)).to be_truthy
      end
    end

    context 'change role of first user' do
      before do
        user.add_role :admin
        post '/users/change_role_admin', params: { user_id: User.first.id }.to_json, headers:
      end

      it 'returns not found status' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        expect(json_body[:errors]).to eq('User not found')
      end
    end
  end
end
