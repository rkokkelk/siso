class AddCreation < ActiveRecord::Migration
  def change
    add_column :repositories, :creation, :date
  end
end
