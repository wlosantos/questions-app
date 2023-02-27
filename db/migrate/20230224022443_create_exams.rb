class CreateExams < ActiveRecord::Migration[7.0]
  def change
    create_table :exams do |t|
      t.string :theme, null: false
      t.integer :status, default: 0
      t.datetime :finished

      t.timestamps
    end
  end
end
