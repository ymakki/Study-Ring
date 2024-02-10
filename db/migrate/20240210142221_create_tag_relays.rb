class CreateTagRelays < ActiveRecord::Migration[6.1]
  def change
    create_table :tag_relays do |t|

      t.timestamps
    end
  end
end
