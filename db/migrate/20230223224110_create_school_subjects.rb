class CreateSchoolSubjects < ActiveRecord::Migration[7.0]
  def change
    create_table :school_subjects do |t|
      t.string :name

      t.timestamps
    end
  end
end
