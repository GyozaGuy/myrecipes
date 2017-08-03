class AddLikesToRecipe < ActiveRecord::Migration[5.1]
  def change
    add_column :recipes, :like_count, :integer, default: 0
    add_column :recipes, :disklike_count, :integer, default: 0
  end
end
