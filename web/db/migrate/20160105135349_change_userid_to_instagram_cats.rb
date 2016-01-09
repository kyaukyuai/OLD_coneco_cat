class ChangeUseridToInstagramCats < ActiveRecord::Migration
  def up
    change_column :instagram_cats, :userid, :integer, :limit => 8
  end

  def down
    change_column :instagram_cats, :userid, :integer
  end
end
