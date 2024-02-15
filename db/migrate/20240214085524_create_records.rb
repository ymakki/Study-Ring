class CreateRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :records do |t|
      t.references :study, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :start_time
      t.integer :study_time
      t.text :word

      t.timestamps
    end
  end
end
