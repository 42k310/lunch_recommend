class AddCalumnToMatches2 < ActiveRecord::Migration
  def change
    add_column :matches, :shop_id, :integer
  end
end
