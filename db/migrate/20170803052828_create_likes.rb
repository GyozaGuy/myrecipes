class CreateLikes < ActiveRecord::Migration[5.1]
  def change
    create_table :likes do |t|
      t.boolean :like
      t.integer :chef_id
      t.integer :recipe_id
      t.timestamps
    end

    remove_column :recipes, :like_count
    remove_column :recipes, :dislike_count
  end
end
