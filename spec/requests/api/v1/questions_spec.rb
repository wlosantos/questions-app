require 'rails_helper'

RSpec.describe "Api::V1::Questions", type: :request do
  before { host! 'api.questions-api.io' }
  let!(:user) { create(:user, :admin, name: 'Wendel Lopes', username: 'wendellopes') }
  let!(:exam) { create(:exam) }
  let!(:token) { JwtAuth::TokenProvider.issue_token({ email: user.email }) }
  let(:headers) do
    {
      'Accept' => 'application/vnd.questions-api.v1',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => "Bearer #{token}"
    }
  end

  describe 'GET /questions' do
    let!(:question) { create(:question, exam:) }
    before { get '/questions', params: {}, headers: }

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns all questions' do
      expect(json_body[:questions].count).to eq(1)
    end
  end

  describe 'GET /questions/:id' do
    let!(:question) { create(:question, exam:) }
    before { get "/questions/#{question.id}", params: {}, headers: }

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the question' do
      expect(json_body[:question][:ask]).to eq(question.ask)
    end
  end

  describe 'POST /questions' do
    before { post '/questions', params: question_params.to_json, headers: }

    context 'when params are valid' do
      let(:question_params) { attributes_for(:question, exam_id: exam.id) }

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the question' do
        expect(json_body[:question][:ask]).to eq(question_params[:ask])
      end
    end

    context 'when params are invalid' do
      let(:question_params) { attributes_for(:question, ask: nil) }

      it 'returns unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error message' do
        expect(json_body[:errors][:ask]).to include("can't be blank")
      end
    end
  end

  describe 'PUT /questions/:id' do
    let!(:question) { create(:question, exam:) }
    before { put "/questions/#{question.id}", params: question_params.to_json, headers: }

    context 'when params are valid' do
      let(:question_params) { { ask: 'New ask' } }

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the question' do
        expect(json_body[:question][:ask]).to eq(question_params[:ask])
      end
    end

    context 'when params are invalid' do
      let(:question_params) { { ask: nil } }

      it 'returns unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error message' do
        expect(json_body[:errors][:ask]).to include("can't be blank")
      end
    end
  end

  describe 'DELETE /questions/:id' do
    let!(:question) { create(:question, exam:) }
    before { delete "/questions/#{question.id}", params: {}, headers: }

    it 'returns success status' do
      expect(response).to have_http_status(:no_content)
    end

    it 'removes the question' do
      expect(Question.find_by(id: question.id)).to be_nil
    end
  end
end
