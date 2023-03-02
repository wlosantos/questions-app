require 'swagger_helper'

describe 'Users API' do
  let(:user) { create(:user, :admin, name: 'Wendel Lopes', username: 'wendellopes') }
  let(:token) { JwtAuth::TokenProvider.issue_token({ email: user.email }) }
  let(:Authorization) { "Bearer #{token}" }
  let(:user_id) { user.id }

  # list all users
  path '/users' do
    get 'List all users' do
      tags 'Users'
      security [Bearer: []]

      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :per_page, in: :query, type: :integer, required: false
      parameter name: :q, in: :query, type: :array, items: { type: :array }, collectionFormat: :multi, required: false,
                description: 'Search by name, username, email, role, example: q[name_cont]=Wendel&q[s]=name+ASC'

      response '200', 'users found' do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :string },
                       type: { type: :string },
                       attributes: {
                         type: :object,
                         properties: {
                           name: { type: :string },
                           username: { type: :string },
                           email: { type: :string },
                           role: { type: :string }
                         },
                         required: %w[name username email role]
                       }
                     },
                     required: %w[id type attributes]
                   }
                 },
                 links: {
                   type: :object,
                   properties: {
                     self: { type: :string, format: :url, example: 'http://localhost:3000/users?page=1&per_page=10' },
                     first: { type: :string, format: :url, example: 'http://localhost:3000/users?page=1&per_page=10' },
                     prev: { type: :null },
                     next: { type: :null },
                     last: { type: :string, format: :url, example: 'http://localhost:3000/users?page=1&per_page=10' }
                   },
                   required: %w[self first prev next last]
                 },
                 meta: {
                   type: :object,
                   properties: {
                     current_page: { type: :integer, example: 1 },
                     total_items: { type: :integer, example: 1 },
                     items_per_page: { type: :integer, example: 1 }
                   },
                   required: %w[current-page total-items items-per-page]
                 }
               },
               required: %w[data links meta]

        let(:page) { 1 }
        let(:per_page) { 10 }
        let(:q) { ['John'] }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'invalid token' }
        run_test!
      end

      response '401', 'Not Authorization' do
        let(:participante) { create(:user) }
        let(:id) { participante.id }
        let(:token) { JwtAuth::TokenProvider.issue_token({ email: participante.email }) }
        let(:Authorization) { "Bearer #{token}" }
        run_test!
      end
    end
  end

  # show user
  path '/users/{id}' do
    get 'Show user' do
      tags 'Users'
      security [Bearer: []]

      produces 'application/json'
      parameter name: :id, in: :path, type: :string, required: true

      response '200', 'user found' do
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
                         name: { type: :string },
                         username: { type: :string },
                         email: { type: :string },
                         role: { type: :string }
                       },
                       required: %w[name username email role]
                     }
                   },
                   required: %w[id type attributes]
                 }
               },
               required: %w[data]

        let(:id) { user_id }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'invalid token' }
        let(:id) { user.id }
        run_test!
      end
    end
  end

  # update user
  path '/users/{id}' do
    put 'Update user' do
      tags 'Users'
      security [Bearer: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, required: true
      parameter name: :participant, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string },
              username: { type: :string },
              email: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string }
            },
            required: %w[name username email password password_confirmation]
          }
        },
        required: %w[user]
      }

      response '200', 'user updated' do
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
                         name: { type: :string },
                         username: { type: :string },
                         email: { type: :string },
                         role: { type: :string }
                       },
                       required: %w[name email username role]
                     }
                   },
                   required: %w[id type attributes]
                 }
               },
               required: %w[data]

        let(:id) { user_id }
        let(:participant) { { user: attributes_for(:user) } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'invalid token' }
        let(:id) { user.id }
        let(:participant) { { user: attributes_for(:user) } }
        run_test!
      end
    end
  end

  # delete user
  path '/users/{id}' do
    delete 'Delete user' do
      tags 'Users'
      security [Bearer: []]

      produces 'application/json'
      parameter name: :id, in: :path, type: :string, required: true

      response '204', 'user deleted' do
        let(:id) { user_id }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'invalid token' }
        let(:id) { user.id }
        run_test!
      end
    end
  end
end
