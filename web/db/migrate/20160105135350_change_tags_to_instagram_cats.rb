class ChangeTagsToInstagramCats < ActiveRecord::Migration
  def up
    change_column :instagram_cats, :tags, :binary
  end

  def down
    change_column :instagram_cats, :tags, :string
  end
end
