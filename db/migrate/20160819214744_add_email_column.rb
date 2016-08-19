class AddEmailColumn < ActiveRecord::Migration
  def change
    add_column('repositories', 'email_enc', :string)
  end
end
