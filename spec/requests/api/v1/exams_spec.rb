require 'rails_helper'

RSpec.describe "Api::V1::Exams", type: :request do
  before { host! 'api.questions-api.io' }
  let!(:user) { create(:user, :admin, name: 'Wendel Lopes', username: 'wendellopes') }
  let!(:school_subject) { create(:school_subject) }
  let!(:token) { JwtAuth::TokenProvider.issue_token({ email: user.email }) }
  let(:headers) do
    {
      'Accept' => 'application/vnd.questions-api.v1',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => "Bearer #{token}"
    }
  end

  describe 'GET /exams' do
    let!(:exam) { create(:exam, school_subject:, user:) }
    before { get '/exams', params: {}, headers: }

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns all exams' do
      expect(json_body[:exams].count).to eq(1)
    end
  end

  describe 'GET /exams/:id' do
    let!(:exam) { create(:exam, school_subject:, user:) }
    before { get "/exams/#{exam.id}", params: {}, headers: }

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the exam' do
      expect(json_body[:exam][:title]).to eq(exam.title)
    end
  end

  describe 'POST /exams' do
    context 'when params are valid' do
      let(:exam_params) { attributes_for(:exam, school_subject_id: school_subject.id) }

      before { post '/exams', params: exam_params.to_json, headers: }

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the exam' do
        expect(json_body[:exam][:title]).to eq(exam_params[:title])
      end
    end

    context 'when params are invalid' do
      let(:exam_params) { attributes_for(:exam, title: nil) }

      before { post '/exams', params: exam_params.to_json, headers: }

      it 'returns unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        expect(json_body[:errors]).to have_key(:title)
      end
    end
  end

  describe 'PUT /exams/:id' do
    let!(:exam) { create(:exam, school_subject:, user:) }

    context 'when params are valid' do
      let(:exam_params) { { title: 'New title' }.to_json }

      before { put "/exams/#{exam.id}", params: exam_params, headers: }

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the updated exam' do
        expect(json_body[:exam][:title]).to eq('New title')
      end
    end

    context 'when params are invalid' do
      let(:exam_params) { { title: nil }.to_json }

      before { put "/exams/#{exam.id}", params: exam_params, headers: }

      it 'returns unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        expect(json_body[:errors]).to have_key(:title)
      end
    end
  end

  describe 'DELETE /exams/:id' do
    let!(:exam) { create(:exam, school_subject:, user:) }

    before { delete "/exams/#{exam.id}", params: {}, headers: }

    it 'returns success status' do
      expect(response).to have_http_status(:no_content)
    end

    it 'removes the exam' do
      expect(Exam.find_by(id: exam.id)).to be_nil
    end
  end
end
