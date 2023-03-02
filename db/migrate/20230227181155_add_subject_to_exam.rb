class AddSubjectToExam < ActiveRecord::Migration[7.0]
  def change
    add_reference :exams, :subject, null: false, foreign_key: true
  end
end
