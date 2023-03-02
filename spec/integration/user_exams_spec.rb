require 'swagger_helper'

describe 'UserExams API' do
  let(:user) { create(:user, name: 'Nadia Nunes', username: 'nnunes') }
  let(:token) { JwtAuth::TokenProvider.issue_token({ email: user.email }) }
  let(:Authorization) { "Bearer #{token}" }
  let(:exam) { create(:exam) }
  let(:user_exam) { create(:user_exam, exam:, user:) }

  # list all user_exams
  path '/user_exams' do
    get 'List all user_exams' do
      tags 'User Exams'
      security [Bearer: []]

      produces 'application/json'

      response '200', 'user_exams found' do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       type: { type: :string },
                       attributes: {
                         type: :object,
                         properties: {
                           user_id: { type: :integer },
                           exam_id: { type: :integer },
                           status: { type: :string },
                           score: { type: :integer }
                         },
                         required: %w[user-id exam-id status score]
                       }
                     },
                     required: %w[id type attributes]
                   }
                 }
               },
               required: %w[data]

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        run_test!
      end
    end
  end

  # show user_exam
  path '/user_exams/{id}' do
    get 'Show user_exam' do
      tags 'User Exams'
      security [Bearer: []]

      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true

      response '200', 'user_exam found' do
        schema type: :object,
               properties: {
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :string },
                     type: { type: :string },
                     attributes: {
                       type: :object,
                       properties: {
                         exam_id: { type: :integer },
                         theme: { type: :string },
                         score: { type: :float },
                         user_answers: {
                           type: :array,
                           items: {
                             type: :object,
                             properties: {
                               id: { type: :integer },
                               question: { type: :integer },
                               answer: { type: :integer },
                               option: { type: :string },
                               response: { type: :boolean }
                             },
                             required: %w[id question answer option response]
                           }
                         }
                       },
                       required: %w[exam-id theme score user-answers]
                     }
                   },
                   required: %w[id type attributes]
                 }
               },
               required: %w[data]

        let(:id) { user_exam.id }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        let(:id) { user_exam.id }
        run_test!
      end
    end
  end
end
