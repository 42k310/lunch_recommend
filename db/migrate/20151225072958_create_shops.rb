class CreateShops < ActiveRecord::Migration
  def change

    create_table :shops do |t|

      # 食べログID（スクレイピングで利用）
      t.string :tblg_id, :null => false, limit: 255
      # ぐるなびID（APIで利用）
      t.string :gnavi_id, :null => false, limit: 255

      t.timestamps

    end
  end
end
