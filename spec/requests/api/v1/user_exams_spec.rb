require 'rails_helper'

RSpec.describe "Api::V1::UserExams", type: :request do
  before { host! 'api.questions-api.io' }
  let!(:participant) { create(:user, name: 'Wendel Lopes', username: 'wendellopes') }
  let!(:exam) { create(:exam, :approved) }
  let!(:token) { JwtAuth::TokenProvider.issue_token({ email: participant.email }) }
  let(:headers) do
    {
      'Accept' => 'application/vnd.questions-api.v1',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => "Bearer #{token}"
    }
  end

  describe 'GET /user_exams' do
    let!(:user_exam) { create(:user_exam, user: participant, exam:) }
    before { get '/user_exams', params: {}, headers: }

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns all user_exams' do
      expect(json_body[:data].count).to eq(1)
    end
  end

  describe 'GET /user_exams/:id' do
    let!(:user_exam) { create(:user_exam, user: participant, exam:) }
    before { get "/user_exams/#{user_exam.id}", params: {}, headers: }

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the user_exam' do
      expect(json_body[:data][:attributes][:'exam-id']).to eq(user_exam.exam_id)
    end
  end

  describe 'POST /user_exams' do
    before { post "/user_exams", params: user_exam_params.to_json, headers: }

    context 'when params are valid' do
      let(:user_exam_params) { attributes_for(:user_exam, user_id: participant.id, exam_id: exam.id) }

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the user_exam' do
        expect(json_body[:data][:attributes][:'exam-id']).to eq(user_exam_params[:exam_id])
      end
    end

    context 'when params are invalid' do
      let(:user_exam_params) { attributes_for(:user_exam, user_id: nil) }

      it 'returns unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end

    context 'when exam finished' do
      let!(:exam_finished) { create(:exam, :approved, finished: Time.now) }
      let(:user_exam_params) { attributes_for(:user_exam, user_id: participant.id, exam: Exam.find(exam_finished.id)) }

      it 'returns unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end

    context 'when exam not approved' do
      let!(:exam_not_approved) { create(:exam, :pending) }
      let(:user_exam_params) { attributes_for(:user_exam, user_id: participant.id, exam: Exam.find(exam_not_approved.id)) }

      it 'returns unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /user_exams/:id' do
    let!(:question) { create(:question, exam:) }
    let!(:answer) { create_list(:answer, 3, question:) }
    let!(:user_exam) { create(:user_exam, user: participant, exam:) }
    let!(:user_answer) { create(:user_answer, question_ref: question.id, answer: answer.first.id, user_exam:) }

    before { put "/user_exams/#{user_exam.id}", params: user_answer_params.to_json, headers: }

    context 'when params are valid' do
      let(:user_answer_params) do
        { user_answer: [
          { question: question.id, answer: answer.last.id }
        ] }
      end

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'DELETE /user_exams/:id' do
    let!(:user_exam) { create(:user_exam, user: participant, exam:) }
    before { delete "/user_exams/#{user_exam.id}", params: {}, headers: }

    it 'returns success status' do
      expect(response).to have_http_status(:no_content)
    end

    it 'removes the user_exam' do
      expect(UserExam.find_by(id: user_exam.id)).to be_nil
    end
  end
end
