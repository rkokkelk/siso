class CreateBricks < ActiveRecord::Migration
  def change
    create_table :bricks do |t|
      t.string :token
      t.binary :blob

      t.timestamps null: false
    end
  end
end
