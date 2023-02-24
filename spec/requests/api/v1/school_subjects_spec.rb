require 'rails_helper'

RSpec.describe "Api::V1::SchoolSubjects", type: :request do
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

  describe 'GET /school_subjects' do
    let!(:subjects) { create(:school_subject) }
    before do
      get '/school_subjects', params: {}, headers:
    end

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns all school subjects' do
      expect(json_body[:school_subjects].count).to eq(1)
    end
  end

  describe 'POST /school_subjects' do
    context 'when params are valid' do
      let(:school_subject_params) { attributes_for(:school_subject) }

      before do
        post '/school_subjects', params: school_subject_params.to_json, headers:
      end

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the school subject' do
        expect(json_body[:school_subject][:name]).to eq(school_subject_params[:name])
      end
    end

    context 'when params are invalid' do
      let(:school_subject_params) { attributes_for(:school_subject, name: nil) }

      before do
        post '/school_subjects', params: school_subject_params.to_json, headers:
      end

      it 'returns unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        expect(json_body[:errors]).to have_key(:name)
      end
    end
  end

  describe 'PUT /school_subjects/:id' do
    let!(:school_subject) { create(:school_subject) }

    context 'when params are valid' do
      let(:school_subject_params) { { name: 'New name' }.to_json }

      before do
        put "/school_subjects/#{school_subject.id}", params: school_subject_params, headers:
      end

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the school subject' do
        expect(json_body[:school_subject][:name]).to eq('New name')
      end
    end

    context 'when params are invalid' do
      let(:school_subject_params) { { name: nil }.to_json }

      before do
        put "/school_subjects/#{school_subject.id}", params: school_subject_params, headers:
      end

      it 'returns unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        expect(json_body[:errors]).to have_key(:name)
      end
    end
  end

  describe 'DELETE /school_subjects/:id' do
    let!(:school_subject) { create(:school_subject) }

    before do
      delete "/school_subjects/#{school_subject.id}", params: {}, headers:
    end

    it 'returns success status' do
      expect(response).to have_http_status(:no_content)
    end

    it 'removes the school subject' do
      expect(SchoolSubject.count).to eq(0)
    end
  end
end
