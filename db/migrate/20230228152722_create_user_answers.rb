class CreateUserAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :user_answers do |t|
      t.references :user_exam, null: false, foreign_key: true
      t.integer :question_ref, null: false
      t.integer :answer, null: false
      t.boolean :trusty, default: false

      t.timestamps
    end
  end
end
