class Messages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.references :user
      t.references :post
      t.text :content
      t.timestamps
    end
  end
end