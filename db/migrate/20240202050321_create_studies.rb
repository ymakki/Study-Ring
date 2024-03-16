class CreateStudies < ActiveRecord::Migration[6.1]
  def change
    create_table :studies do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
