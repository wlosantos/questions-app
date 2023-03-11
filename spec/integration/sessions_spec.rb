require 'swagger_helper'

RSpec.describe 'Sessions Api' do
  before { host! 'question-api-arbon.ondigitalocean.app' }
  let(:account) { create(:user, :admin) }
  let(:token) { JwtAuth::TokenProvider.issue_token({ email: account.email }) }

  path '/sessions' do
    post 'Creates a session' do
      tags 'Sessions'
      security [Bearer: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[email password]
      }

      response '401', 'Invalid credentials' do
        let(:Authorization) { '' }
        let(:user) { { user: attributes_for(:user, username: nil) } }
        run_test!
      end
    end
  end
end
