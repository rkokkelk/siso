class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :iv_enc
      t.string :master_key_enc
      t.string :password_digest
      t.string :title_enc
      t.text :description_enc
      t.date :deletion
    end
  end
end
