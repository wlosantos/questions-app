require 'swagger_helper'

describe 'Answers API' do
  let(:user) { create(:user, :admin, name: 'Wendel Lopes', username: 'wendellopes') }
  let(:token) { JwtAuth::TokenProvider.issue_token({ email: user.email }) }
  let(:Authorization) { "Bearer #{token}" }
  let(:question) { create(:question) }
  let(:question_id) { question.id }
  let(:answer) { create(:answer, question:) }

  # list all answers
  path '/answers' do
    get 'List all answers' do
      tags 'Answers'
      security [Bearer: []]

      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :per_page, in: :query, type: :integer, required: false
      parameter name: :q, in: :query, type: :array, items: { type: :array }, collectionFormat: :multi, required: false,
                description: 'Search by answer or correct, example: q[answer_cont]=change&q[s]=answer+ASC'

      response '200', 'answers found' do
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
                           answer: { type: :string },
                           correct: { type: :boolean },
                           question_id: { type: :integer }
                         },
                         required: %w[answer correct question-id]
                       }
                     },
                     required: %w[id type attributes]
                   }
                 },
                 links: {
                   type: :object,
                   properties: {
                     self: { type: :string, format: :url, example: 'http://localhost:3000/answers?page=1&per_page=10' },
                     first: { type: :string, format: :url, example: 'http://localhost:3000/answers?page=1&per_page=10' },
                     prev: { type: :null },
                     next: { type: :null },
                     last: { type: :string, format: :url, example: 'http://localhost:3000/answers?page=1&per_page=10' }
                   },
                   required: %w[self first prev next last]
                 },
                 meta: {
                   type: :object,
                   properties: {
                     current_page: { type: :integer, example: 1 },
                     total_items: { type: :integer, example: 5 },
                     items_per_page: { type: :integer, example: 10 }
                   },
                   required: %w[current-page total-items items-per-page]
                 }
               },
               required: %w[data links meta]

        let(:page) { 1 }
        let(:per_page) { 10 }
        let(:q) { ['change'] }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        run_test!
      end
    end
  end

  # show answer
  path '/answers/{id}' do
    get 'Show answer' do
      tags 'Answers'
      security [Bearer: []]

      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true

      response '200', 'answer found' do
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
                         response: { type: :string },
                         corrected: { type: :boolean },
                         question_id: { type: :integer }
                       },
                       required: %w[response corrected question-id]
                     }
                   },
                   required: %w[id type attributes]
                 }
               },
               required: %w[data]

        let(:id) { answer.id }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        let(:id) { answer.id }
        run_test!
      end
    end
  end
end
