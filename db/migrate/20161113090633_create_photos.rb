class CreatePhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :photos do |t|
      t.string :name
      t.text :desc
      t.string :image
      t.jsonb :exif

      t.timestamps
    end
  end
end
