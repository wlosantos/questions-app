class AddBlockedToExam < ActiveRecord::Migration[7.0]
  def change
    add_column :exams, :blocked, :boolean, default: false
  end
end
