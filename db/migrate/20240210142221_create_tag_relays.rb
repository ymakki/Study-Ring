class CreateTagRelays < ActiveRecord::Migration[6.1]
  def change
    create_table :tag_relays do |t|
      t.references :study, foreign_key: true, null: false
      t.references :tag, foreign_key: true, null: false

      t.timestamps
    end
  end
end
