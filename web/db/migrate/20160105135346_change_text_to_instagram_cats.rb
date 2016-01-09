class ChangeTextToInstagramCats < ActiveRecord::Migration
  def up
    change_column :instagram_cats, :text, :binary
  end

  def down
    change_column :instagram_cats, :text, :string
  end
end
