require 'swagger_helper'

describe 'Exams API' do
  let(:user) { create(:user, :admin, name: 'Wendel Lopes', username: 'wendellopes') }
  let(:token) { JwtAuth::TokenProvider.issue_token({ email: user.email }) }

  path '/exams' do
    get 'Retrieves exams' do
      tags 'Exams'
      security [Bearer: []]

      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :per_page, in: :query, type: :integer, required: false

      # list all exams
      response '200', 'exams found' do
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
                           theme: { type: :string },
                           subject: { type: :string },
                           created: { type: :string },
                           finished: { type: :string }
                         },
                         required: %w[theme subject created finished]
                       }
                     },
                     required: %w[id type attributes]
                   }
                 }
               },
               required: %w[data]

        let(:page) { 1 }
        let(:per_page) { 10 }
        let(:Authorization) { "Bearer #{token}" }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'invalid' }
        run_test!
      end
    end
  end
end
