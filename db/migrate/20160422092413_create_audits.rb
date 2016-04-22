class CreateAudits < ActiveRecord::Migration
  def change
    create_table :audits do |t|
      t.string :token
      t.string :message
      t.date :deletion

      t.timestamps null: false
    end
  end
end
