class CreateReads < ActiveRecord::Migration
  def change
    create_table :reads do |t|
      t.references :user, index: true
      t.references :document, index: true

      t.timestamps
    end
  end
end
