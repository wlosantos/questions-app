require 'swagger_helper'

describe 'UserExams API' do
  let(:user) { create(:user, name: 'Nadia Nunes', username: 'nnunes') }
  let(:token) { JwtAuth::TokenProvider.issue_token({ email: user.email }) }
  let(:Authorization) { "Bearer #{token}" }
  let(:exam) { create(:exam) }
  let(:user_exam) { create(:user_exam, exam:, user:) }

  let(:question) { create(:question, exam:) }
  let(:answer) { create_list(:answer, 3, question:) }

  # list all user_exams
  path '/user_exams' do
    get 'List all user_exams' do
      tags 'User Exams'
      security [Bearer: []]

      produces 'application/json'

      response '200', 'user_exams found' do
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
                           user_id: { type: :integer },
                           exam_id: { type: :integer },
                           status: { type: :string },
                           score: { type: :integer }
                         },
                         required: %w[user-id exam-id status score]
                       }
                     },
                     required: %w[id type attributes]
                   }
                 }
               },
               required: %w[data]

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        run_test!
      end
    end
  end

  # show user_exam
  path '/user_exams/{id}' do
    get 'Show user_exam' do
      tags 'User Exams'
      security [Bearer: []]

      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true

      response '200', 'user_exam found' do
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
                         exam_id: { type: :integer },
                         theme: { type: :string },
                         score: { type: :float },
                         user_answers: {
                           type: :array,
                           items: {
                             type: :object,
                             properties: {
                               id: { type: :integer },
                               question: { type: :integer },
                               answer: { type: :integer },
                               option: { type: :string },
                               response: { type: :boolean }
                             },
                             required: %w[id question answer option response]
                           }
                         }
                       },
                       required: %w[exam-id theme score user-answers]
                     }
                   },
                   required: %w[id type attributes]
                 }
               },
               required: %w[data]

        let(:id) { user_exam.id }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        let(:id) { user_exam.id }
        run_test!
      end
    end
  end

  # create user_exam
  path '/user_exams' do
    post 'Create user_exam' do
      tags 'User Exams'
      security [Bearer: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :user_exam, in: :body, schema: {
        type: :object,
        properties: {
          user_exam: {
            type: :object,
            properties: {
              exam_id: { type: :integer }
            },
            required: %w[exam-id]
          }
        },
        required: %w[user-exam]
      }

      response '200', 'user_exam created' do
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
                         exam_id: { type: :integer },
                         theme: { type: :string },
                         score: { type: :float }
                       },
                       required: %w[exam-id theme score]
                     }
                   },
                   required: %w[id type attributes]
                 }
               },
               required: %w[data]

        let(:user_exam) { { user_id: user.id, exam_id: exam.id, score: 0 } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user_exam) { { user_id: user.id, exam_id: nil } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        let(:user_exam) { { user_id: user.id, exam_id: exam.id, score: 0 } }
        run_test!
      end
    end
  end

  # delete user_exam
  path '/user_exams/{id}' do
    delete 'Delete user_exam' do
      tags 'User Exams'
      security [Bearer: []]

      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true

      response '204', 'user_exam deleted' do
        let(:id) { user_exam.id }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        let(:id) { user_exam.id }
        run_test!
      end
    end
  end

  # update user_exam
  path '/user_exams/{id}' do
    put 'Correction of the tests' do
      tags 'User Exams'
      security [Bearer: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :user_answer, in: :body, schema: {
        type: :object,
        properties: {
          user_answer: {
            type: :array,
            items: {
              type: :object,
              properties: {
                question: { type: :integer },
                answer: { type: :integer }
              },
              required: %w[question answer]
            }
          }
        },
        required: %w[user-answer]
      }

      before do
        create(:user_answer, user_exam:, question_ref: question.id, answer: answer.first.id)
      end

      response '200', 'user_exam updated' do
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
                         exam_id: { type: :integer },
                         theme: { type: :string },
                         score: { type: :float },
                         user_answers: {
                           type: :array,
                           items: {
                             type: :object,
                             properties: {
                               id: { type: :integer },
                               question: { type: :integer },
                               answer: { type: :integer },
                               option: { type: :string },
                               response: { type: :boolean }
                             },
                             required: %w[id question answer option response]
                           }
                         }
                       },
                       required: %w[exam-id theme score user-answers]
                     }
                   },
                   required: %w[id type attributes]
                 }
               },
               required: %w[data]

        let(:id) { user_exam.id }
        let(:user_answer) { { user_answer: [{ question: question.id, answer: answer.sample.id }] } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { user_exam.id }
        let(:user_answer) { { user_answer: [{ question: -1, answer: answer.sample.id }] } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        let(:id) { user_exam.id }
        let(:user_answer) { { user_answer: [{ question: question.id, answer: answer.sample.id }] } }
        run_test!
      end
    end
  end
end
