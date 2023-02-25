class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.integer :comments_count
      t.integer :likes_count
      t.string :username
      t.boolean :private

      t.timestamps
    end
  end
end
