class AddPictureToGrams < ActiveRecord::Migration[5.2]
  def change
    add_column :grams, :photo, :string
  end
end
