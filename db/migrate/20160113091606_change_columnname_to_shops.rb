class ChangeColumnnameToShops < ActiveRecord::Migration
  def change
    rename_column :shops, :tblg_id, :gnavi_id
    remove_column :shops, :tblg_id
  end
end
