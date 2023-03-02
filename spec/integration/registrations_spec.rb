require 'swagger_helper'

describe 'Registrations API' do
  path '/registrations' do
    post 'Creates a registration' do
      tags 'Registrations'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string },
              email: { type: :string },
              username: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string }
            },
            required: %w[name email username password password_confirmation]
          }
        },
        required: %w[user]
      }

      response '201', 'registration created' do
        let(:Authorization) { '' }
        let(:user) { { user: attributes_for(:user) } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:Authorization) { '' }
        let(:user) { { user: attributes_for(:user, username: nil) } }
        run_test!
      end
    end
  end
end
