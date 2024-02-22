class CreateStudyTaggings < ActiveRecord::Migration[6.1]
  def change
    create_table :study_taggings do |t|
      t.references :study, foreign_key: true
      t.references :tag, foreign_key: true
      t.timestamps
    end
  end
end
