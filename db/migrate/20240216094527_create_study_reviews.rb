class CreateStudyReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :study_reviews do |t|
      t.references :user, foreign_key: true, null: false
      t.references :study, foreign_key: true, null: false
      t.text :title
      t.text :body

      t.timestamps
    end
  end
end
