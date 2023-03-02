require 'rails_helper'

RSpec.describe "Api::V1::Subjects", type: :request do
  before { host! 'api.questions-api.io' }
  let!(:user) { create(:user, :admin, name: 'Wendel Lopes', username: 'wendellopes') }
  let!(:token) { JwtAuth::TokenProvider.issue_token({ email: user.email }) }
  let(:headers) do
    {
      'Accept' => 'application/vnd.questions-api.v1',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => "Bearer #{token}"
    }
  end

  describe 'GET /subjects' do
    let!(:subjects) { create(:subject) }
    before do
      get '/subjects', params: {}, headers:
    end

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns all school subjects' do
      expect(json_body[:data].size).to eq(1)
    end

    context 'when user is not admin' do
      let!(:user) { create(:user, name: 'Wendel Lopes', username: 'wendellopes') }

      it 'returns forbidden status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error message' do
        expect(json_body[:error]).to eq('No Authorization!')
      end
    end
  end

  describe 'POST /subjects' do
    context 'when params are valid' do
      let(:subject_params) { attributes_for(:subject) }

      before do
        post '/subjects', params: subject_params.to_json, headers:
      end

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the school subject' do
        expect(json_body[:data][:attributes][:name]).to eq(subject_params[:name])
      end
    end

    context 'when params are invalid' do
      let(:subject_params) { attributes_for(:subject, name: nil) }

      before do
        post '/subjects', params: subject_params.to_json, headers:
      end

      it 'returns unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        expect(json_body[:errors]).to have_key(:name)
      end
    end
  end

  describe 'PUT /subjects/:id' do
    let!(:subject) { create(:subject) }

    context 'when params are valid' do
      let(:subject_params) { { name: 'New name' }.to_json }

      before do
        put "/subjects/#{subject.id}", params: subject_params, headers:
      end

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the school subject' do
        expect(json_body[:data][:attributes][:name]).to eq('New name')
      end
    end

    context 'when params are invalid' do
      let(:subject_params) { { name: nil }.to_json }

      before do
        put "/subjects/#{subject.id}", params: subject_params, headers:
      end

      it 'returns unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        expect(json_body[:errors]).to have_key(:name)
      end
    end
  end

  describe 'DELETE /subjects/:id' do
    let!(:subject) { create(:subject) }

    before do
      delete "/subjects/#{subject.id}", params: {}, headers:
    end

    it 'returns success status' do
      expect(response).to have_http_status(:no_content)
    end

    it 'removes the subject' do
      expect(Subject.count).to eq(0)
    end
  end
end
