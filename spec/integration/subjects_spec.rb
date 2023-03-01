require 'swagger_helper'

describe 'Subjects API', swagger_doc: 'v1/swagger.yaml' do
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
end
