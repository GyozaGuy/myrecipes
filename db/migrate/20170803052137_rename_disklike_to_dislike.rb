class RenameDisklikeToDislike < ActiveRecord::Migration[5.1]
  def change
    rename_column :recipes, :disklike_count, :dislike_count
  end
end
