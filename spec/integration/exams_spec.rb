require 'swagger_helper'

describe 'Exams API' do
  let(:user) { create(:user, :admin, name: 'Wendel Lopes', username: 'wendellopes') }
  let(:token) { JwtAuth::TokenProvider.issue_token({ email: user.email }) }
  let(:subject) { create(:subject) }

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

  # show exam
  path '/exams/{id}' do
    get 'Show an exam' do
      tags 'Exams'
      security [Bearer: []]

      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'exam found' do
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
                         theme: { type: :string },
                         subject: { type: :string },
                         created: { type: :string },
                         finished: { type: :null },
                         questions: {
                           type: :array,
                           items: {
                             type: :object,
                             properties: {
                               id: { type: :integer },
                               ask: { type: :string },
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
                             required: %w[id ask answer]
                           }
                         }
                       },
                       required: %w[theme subject created finished]
                     }
                   }
                 }
               }

        let(:id) { create(:exam).id }
        let(:Authorization) { "Bearer #{token}" }
        run_test!
      end
    end
  end

  # create exam
  path '/exams' do
    post 'Create a exam' do
      tags 'Exams'
      security [Bearer: []]

      consumes 'application/json'
      produces 'applications/json'

      parameter name: :exam, in: :body, schema: {
        type: :object,
        properties: {
          exam: {
            type: :object,
            properties: {
              theme: { type: :string },
              subject_id: { type: :string }
            },
            required: %w[theme subject_id]
          }
        },
        required: %w[exam]
      }

      response '200', 'exam created' do
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
                         theme: { type: :string },
                         subject: { type: :string },
                         created: { type: :string },
                         finished: { type: :null }
                       },
                       required: %w[theme subject created finished]
                     }
                   },
                   required: %w[id type attributes]
                 }
               },
               required: %w[data]

        let(:Authorization) { "Bearer #{token}" }
        let(:exam) { attributes_for(:exam, theme: 'Avaliation of Math', subject_id: subject.id) }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'invalid' }
        let(:exam) { attributes_for(:exam, theme: 'Avaliation of Math', subject_id: subject.id) }
        run_test!
      end

      response '422', 'invalid request' do
        let(:Authorization) { "Bearer #{token}" }
        let(:exam) { attributes_for(:exam, theme: nil, subject_id: subject.id) }
        run_test!
      end
    end
  end
end
