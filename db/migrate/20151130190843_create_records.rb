class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :iv
      t.string :token
      t.string :file_name
      t.integer :size
      t.date :creation
      t.belongs_to :repositories, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
