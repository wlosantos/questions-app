require 'rails_helper'

RSpec.describe "Api::V1::Registrations", type: :request do
  before { host! 'question-api-arbon.ondigitalocean.app' }
  let(:headers) do
    {
      'Accept' => 'application/vnd.questions-api.v1',
      'Content-Type' => Mime[:json].to_s
    }
  end

  describe 'POST /registrations' do
    before do
      post '/registrations', params: user_params.to_json, headers:
    end

    context 'when the request params are valid' do
      let(:user_params) { { user: attributes_for(:user) } }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns json data for the created user' do
        expect(json_body[:success]).to match(/Welcome! You have signed up successfully./)
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) { { user: attributes_for(:user, email: 'invalid_email@') } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end

    context 'when the email is already taken' do
      let!(:user_exist) { create(:user, email: 'contact@repeat.com') }
      let(:user_params) { { user: attributes_for(:user, email: user_exist.email) } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end
end
