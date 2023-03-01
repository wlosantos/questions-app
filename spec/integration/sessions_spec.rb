require 'swagger_helper'

RSpec.describe 'Api::V1::Sessions', type: :request do
  path '/sessions' do
    post 'Creates a session' do
      tags 'Sessions'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[email password]
      }

      response '401', 'Invalid credentials' do
        let(:user) { { user: attributes_for(:user, username: nil) } }
        run_test!
      end
    end
  end
end
