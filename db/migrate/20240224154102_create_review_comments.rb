class CreateReviewComments < ActiveRecord::Migration[6.1]
  def change
    create_table :review_comments do |t|
      t.references :user, foreign_key: true, null: false
      t.references :study_review, foreign_key: true, null: false
      t.text :comment

      t.timestamps
    end
  end
end
