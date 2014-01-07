class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :username, index: true
      t.string :password_digest
      t.string :email, index: true
      t.boolean :admin

      t.timestamps
    end
  end
end
