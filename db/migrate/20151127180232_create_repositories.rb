class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :iv
      t.string :title
      t.string :master_key
      t.string :pass
      t.string :token
      t.text :description
      t.date :created
      t.date :deletion

      t.timestamps null: false
    end
  end
end
