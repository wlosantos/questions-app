require 'swagger_helper'

describe 'Questions API' do
  before { host! 'question-api-arbon.ondigitalocean.app' }
  let(:user) { create(:user, :admin, name: 'Wendel Lopes', username: 'wendellopes') }
  let(:token) { JwtAuth::TokenProvider.issue_token({ email: user.email }) }
  let(:exam) { create(:exam) }
  let(:exam_id) { exam.id }
  let(:question) { create(:question, exam:) }

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
        let(:q) { ['ask_cont', 'ask ASC'] }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'invalid' }
        run_test!
      end
    end
  end

  # show question
  path '/exams/{exam_id}/questions/{id}' do
    get 'Show a question' do
      tags 'Questions'
      security [Bearer: []]

      produces 'application/json'
      parameter name: :exam_id, in: :path, type: :integer, required: true
      parameter name: :id, in: :path, type: :integer, required: true

      response '200', 'question found' do
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
                         ask: { type: :string },
                         exam_id: { type: :integer },
                         answers: {
                           type: :array,
                           items: {
                             type: :object,
                             properties: {
                               id: { type: :integer },
                               response: { type: :string },
                               corrected: { type: :boolean }
                             },
                             required: %w[id response corrected]
                           }
                         }
                       },
                       required: %w[ask exam-id answers]
                     }
                   },
                   required: %w[id type attributes]
                 }
               },
               required: %w[data]

        let(:Authorization) { "Bearer #{token}" }
        let(:exam_id) { exam.id }
        let(:id) { question.id }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'invalid' }
        let(:exam_id) { exam.id }
        let(:id) { question.id }
        run_test!
      end
    end
  end

  # create question
  path '/exams/{exam_id}/questions' do
    post 'Create a question' do
      tags 'Questions'
      security [Bearer: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :exam_id, in: :path, type: :integer, required: true
      parameter name: :question, in: :body, schema: {
        type: :object,
        properties: {
          question: {
            type: :object,
            properties: {
              ask: { type: :string }
            },
            required: %w[ask]
          }
        },
        required: %w[question]
      }

      response '200', 'question created' do
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
                         ask: { type: :string },
                         exam_id: { type: :integer }
                       },
                       required: %w[ask exam-id]
                     }
                   },
                   required: %w[id type attributes]
                 }
               },
               required: %w[data]

        let(:Authorization) { "Bearer #{token}" }
        let(:exam_id) { exam.id }
        let(:question) { { question: { ask: 'What is the capital of Brazil?' } } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'invalid' }
        run_test!
      end

      response '422', 'invalid request' do
        let(:Authorization) { "Bearer #{token}" }
        let(:question) { { question: { ask: '' } } }
        run_test!
      end

      response '404', 'exam blocked' do
        let(:Authorization) { "Bearer #{token}" }
        let(:exam_id) { create(:exam, :blocked) }
        let(:question) { { question: { ask: 'What is the capital of Brazil?' } } }
      end
    end
  end

  # update question
  path '/questions/{id}' do
    put 'Update a question' do
      tags 'Questions'
      security [Bearer: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer, required: true

      parameter name: :question, in: :body, schema: {
        type: :object,
        properties: {
          question: {
            type: :object,
            properties: {
              ask: { type: :string }
            },
            required: %w[ask]
          }
        },
        required: %w[question]
      }

      response '200', 'question updated' do
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
                         ask: { type: :string },
                         exam_id: { type: :integer }
                       },
                       required: %w[ask exam-id]
                     }
                   },
                   required: %w[id type attributes]
                 }
               },
               required: %w[data]

        let(:Authorization) { "Bearer #{token}" }
        let(:id) { create(:question, exam:).id }
        let(:question) { attributes_for(:question, ask: 'Wich is the president of the Brazil') }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'invalid' }
        let(:id) { question.id }
        run_test!
      end
    end
  end

  # delete question
  path '/questions/{id}' do
    delete 'Delete a question' do
      tags 'Questions'
      security [Bearer: []]

      consumes 'application/json'

      parameter name: :id, in: :path, type: :integer, required: true

      response '204', 'question deleted' do
        let(:Authorization) { "Bearer #{token}" }
        let(:id) { question.id }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'invalid' }
        let(:id) { question.id }
        run_test!
      end
    end
  end
end
