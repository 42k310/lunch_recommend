class CreateShops < ActiveRecord::Migration
  def change

    create_table :shops do |t|

      # ぐるなびID（APIで利用）
      t.string :gnavi_id, :null => false, limit: 255
      # 食べログID（スクレイピングで利用）
      t.string :tblg_id, :null => false, limit: 255

      t.timestamps

    end

    add_index :shops, :gnavi_id, :unique => true, :name => 'unq_sp_on_gnavi_id'
    add_index :shops, :tblg_id, :unique => true, :name => 'unq_sp_on_tblg_id'
  end
end
