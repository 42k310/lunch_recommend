class ChangeColumnToShops < ActiveRecord::Migration
  def change
    change_column :shops, :tblg_id, :text
  end
end
