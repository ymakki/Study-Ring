class CreateReviewFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :review_favorites do |t|
      t.references :user, foreign_key: true, null: false
      t.references :study_review, foreign_key: true, null: false

      t.timestamps
    end
  end
end
