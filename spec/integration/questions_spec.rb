require 'swagger_helper'

describe 'Questions API' do
  let(:user) { create(:user, :admin, name: 'Wendel Lopes', username: 'wendellopes') }
  let(:token) { JwtAuth::TokenProvider.issue_token({ email: user.email }) }
  let(:exam) { create(:exam) }

  # list all questions
  path '/questions' do
    get 'List all questions' do
      tags 'Questions'
      security [Bearer: []]

      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :per_page, in: :query, type: :integer, required: false
      parameter name: :q, in: :query, type: :array, items: { type: :string }, collectionFormat: :multi, required: false

      response '200', 'questions found' do
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
                           ask: { type: :string },
                           exam_id: { type: :integer }
                         },
                         required: %w[ask exam-id]
                       }
                     },
                     required: %w[id type attributes]
                   }
                 },
                 links: {
                   type: :object,
                   properties: {
                     self: { type: :string, format: :url, example: 'http://localhost:3000/questions?page=1&per_page=10' },
                     first: { type: :string, format: :url, example: 'http://localhost:3000/questions?page=1&per_page=10' },
                     prev: { type: :null },
                     next: { type: :null },
                     last: { type: :string, format: :url, example: 'http://localhost:3000/questions?page=1&per_page=10' }
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
               required: %w[data]

        let(:Authorization) { "Bearer #{token}" }
        let(:page) { 1 }
        let(:per_page) { 5 }
        let(:q) { ['ask', 'ask ASC'] }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'invalid' }
        run_test!
      end
    end
  end
end
