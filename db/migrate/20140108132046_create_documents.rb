class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :title
      t.string :description
      t.string :guid
      t.integer :user_id

      t.timestamps
    end
  end
end
