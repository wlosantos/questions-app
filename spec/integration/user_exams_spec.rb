require 'swagger_helper'

describe 'UserExams API' do
  let(:user) { create(:user, name: 'Nadia Nunes', username: 'nnunes') }
  let(:token) { JwtAuth::TokenProvider.issue_token({ email: user.email }) }
  let(:Authorization) { "Bearer #{token}" }
  let(:exam) { create(:exam) }
  let(:user_exam) { create(:user_exam, exam:) }

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
end
