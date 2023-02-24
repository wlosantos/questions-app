require 'rails_helper'

RSpec.describe "Api::V1::Answers", type: :request do
  before { host! 'api.questions-api.io' }
  let!(:user) { create(:user, :admin) }
  let!(:question) { create(:question, user:) }
  let!(:token) { JwtAuth::TokenProvider.issue_token({ email: user.email }) }
  let(:headers) do
    {
      'Accept' => 'application/vnd.questions-api.v1',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => "Bearer #{token}"
    }
  end

  describe 'GET /questions/:question_id/answers' do
    let!(:answers) { create_list(:answer, 5, question:) }
    before { get "/questions/#{question.id}/answers", params: {}, headers: }

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns all answers' do
      expect(json_body[:answers].count).to eq(5)
    end
  end

  describe 'GET /questions/:question_id/answers/:id' do
    let!(:answer) { create(:answer, question:) }
    before { get "/questions/#{question.id}/answers/#{answer.id}", params: {}, headers: }

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the answer' do
      expect(json_body[:answer][:description]).to eq(answer.description)
    end
  end

  describe 'POST /questions/:question_id/answers' do
    before { post "/questions/#{question.id}/answers", params: { answer: answer_params }.to_json, headers: }

    context 'when the params are valid' do
      let(:answer_params) { attributes_for(:answer) }

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'saves the answer in the database' do
        expect(Answer.find_by(description: answer_params[:description])).not_to be_nil
      end

      it 'returns the json for created answer' do
        expect(json_body[:answer][:description]).to eq(answer_params[:description])
      end
    end

    context 'when the params are invalid' do
      let(:answer_params) { attributes_for(:answer, description: ' ') }

      it 'returns unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not save the answer in the database' do
        expect(Answer.find_by(description: answer_params[:description])).to be_nil
      end

      it 'returns the json error for description' do
        expect(json_body[:errors]).to have_key(:description)
      end
    end
  end

  describe 'PUT /questions/:question_id/answers/:id' do
    let!(:answer) { create(:answer, question:) }

    before { put "/questions/#{question.id}/answers/#{answer.id}", params: { answer: answer_params }.to_json, headers: }

    context 'when the params are valid' do
      let(:answer_params) { { description: 'New answer description' } }

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the json for updated answer' do
        expect(json_body[:answer][:description]).to eq(answer_params[:description])
      end

      it 'updates the answer in the database' do
        expect(Answer.find_by(description: answer_params[:description])).not_to be_nil
      end
    end

    context 'when the params are invalid' do
      let(:answer_params) { { description: ' ' } }

      it 'returns unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the json error for description' do
        expect(json_body[:errors]).to have_key(:description)
      end

      it 'does not update the answer in the database' do
        expect(Answer.find_by(description: answer_params[:description])).to be_nil
      end
    end
  end

  describe 'DELETE /questions/:question_id/answers/:id' do
    let!(:answer) { create(:answer, question:) }

    before { delete "/questions/#{question.id}/answers/#{answer.id}", params: {}, headers: }

    it 'returns success status' do
      expect(response).to have_http_status(:no_content)
    end

    it 'removes the answer from the database' do
      expect { Answer.find(answer.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
