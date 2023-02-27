require 'rails_helper'

RSpec.describe "Api::V1::Exams", type: :request do
  before { host! 'api.questions-api.io' }
  let!(:user) { create(:user, :admin, name: 'Wendel Lopes', username: 'wendellopes') }
  let!(:subject) { create(:subject) }
  let!(:token) { JwtAuth::TokenProvider.issue_token({ email: user.email }) }
  let(:headers) do
    {
      'Accept' => 'application/vnd.questions-api.v1',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => "Bearer #{token}"
    }
  end

  describe 'GET /exams' do
    let!(:exam) { create(:exam, subject:) }
    before { get '/exams', params: {}, headers: }

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns all exams' do
      expect(json_body[:data].size).to eq(1)
    end
  end

  describe 'GET /exams/:id' do
    let!(:exam) { create(:exam, subject:) }
    before { get "/exams/#{exam.id}", params: {}, headers: }

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the exam' do
      expect(json_body[:data][:attributes][:theme]).to eq(exam.theme)
    end
  end

  describe 'POST /exams' do
    context 'when params are valid' do
      let(:exam_params) { attributes_for(:exam, subject_id: subject.id) }

      before { post '/exams', params: exam_params.to_json, headers: }

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the exam' do
        expect(json_body[:data][:attributes][:theme]).to eq(exam_params[:theme])
      end
    end

    context 'when params are invalid' do
      let(:exam_params) { attributes_for(:exam, theme: nil) }

      before { post '/exams', params: exam_params.to_json, headers: }

      it 'returns unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        expect(json_body[:errors]).to have_key(:theme)
      end
    end
  end

  describe 'PUT /exams/:id' do
    let!(:exam) { create(:exam, subject:) }

    context 'when params are valid' do
      let(:exam_params) { { theme: 'New theme' }.to_json }

      before { put "/exams/#{exam.id}", params: exam_params, headers: }

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the updated exam' do
        expect(json_body[:data][:attributes][:theme]).to eq('New theme')
      end
    end

    context 'when params are invalid' do
      let(:exam_params) { { theme: nil }.to_json }

      before { put "/exams/#{exam.id}", params: exam_params, headers: }

      it 'returns unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        expect(json_body[:errors]).to have_key(:theme)
      end
    end
  end

  describe 'DELETE /exams/:id' do
    let!(:exam) { create(:exam, subject:) }

    before { delete "/exams/#{exam.id}", params: {}, headers: }

    it 'returns success status' do
      expect(response).to have_http_status(:no_content)
    end

    it 'removes the exam' do
      expect(Exam.find_by(id: exam.id)).to be_nil
    end
  end
end
