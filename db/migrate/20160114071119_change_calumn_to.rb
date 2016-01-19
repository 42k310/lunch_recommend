class ChangeCalumnTo < ActiveRecord::Migration
  def change
    remove_column :matches, :shop_id
  end
end
