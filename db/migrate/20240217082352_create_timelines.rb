class CreateTimelines < ActiveRecord::Migration[6.1]
  def change
    create_table :timelines do |t|
      t.integer :user_id
      t.integer :record_id
      t.integer :study_review_id

      t.timestamps
    end
  end
end
