require 'swagger_helper'

describe 'Subjects API' do
  let(:user) { create(:user, :admin, name: 'Wendel Lopes', username: 'wendellopes') }
  let(:token) { JwtAuth::TokenProvider.issue_token({ email: user.email }) }

  path '/subjects' do
    get 'Retrieves all school subjects' do
      tags 'Subjects'
      security [Bearer: []]
      # consumes 'application/vnd.questions-api.v1'
      produces 'application/vnd.questions-api.v1'

      response '200', 'subjects found' do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer, example: 1 },
                       type: { type: :string, example: 'subjects' },
                       attributes: {
                         type: :object,
                         properties: {
                           name: { type: :string, example: 'Math' }
                         },
                         required: %w[name]
                       }
                     },
                     required: %w[id type attributes]
                   }
                 }
               },
               required: %w[data]

        let(:Authorization) { "Bearer #{token}" }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'invalid' }
        run_test!
      end
    end
  end

  # create subject
  path '/subjects' do
    post 'Creates a subject' do
      tags 'Subjects'
      security [Bearer: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :subject, in: :body, schema: {
        type: :object,
        properties: {
          subject: {
            type: :object,
            properties: {
              name: { type: :string, example: 'Biologia' }
            },
            required: %w[name]
          }
        },
        required: %w[subject]
      }

      response '200', 'subject created' do
        let(:Authorization) { "Bearer #{token}" }
        let(:subject) { attributes_for(:subject, name: 'Biologia') }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { '' }
        let(:subject) { { subject: attributes_for(:subject, name: 'Biologia') } }
        run_test!
      end
    end
  end

  # update subject
  path '/subjects/{id}' do
    put 'Updates a subject' do
      tags 'Subjects'
      security [Bearer: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer
      parameter name: :subject, in: :body, schema: {
        type: :object,
        properties: {
          subject: {
            type: :object,
            properties: {
              name: { type: :string }
            },
            required: %w[name]
          }
        },
        required: %w[subject]
      }

      response '200', 'subject updated' do
        let(:Authorization) { "Bearer #{token}" }
        let(:id) { create(:subject).id }
        let(:subject) { { subject: attributes_for(:subject, name: 'Biologia') } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { '' }
        let(:id) { create(:subject).id }
        let(:subject) { { subject: attributes_for(:subject, name: 'Biologia') } }
        run_test!
      end

      response '422', 'subject not found' do
        let(:Authorization) { "Bearer #{token}" }
        let(:id) { create(:subject).id }
        let(:subject) { { subject: attributes_for(:subject, name: nil) } }
        run_test!
      end
    end
  end

  # delete subject
  path '/subjects/{id}' do
    delete 'Deletes a subject' do
      tags 'Subjects'
      security [Bearer: []]

      consumes 'application/json'

      parameter name: :id, in: :path, type: :integer

      response '204', 'subject deleted' do
        let(:Authorization) { "Bearer #{token}" }
        let(:id) { create(:subject).id }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { '' }
        let(:id) { create(:subject).id }
        run_test!
      end
    end
  end
end
