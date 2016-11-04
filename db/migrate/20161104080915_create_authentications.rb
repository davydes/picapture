class CreateAuthentications < ActiveRecord::Migration[5.0]
  def change
    create_table :authentications do |t|
      t.references :user, foreign_key: true
      t.string :provider
      t.string :uid
    end
    add_index :authentications, [:provider, :uid], unique: true
  end
end
