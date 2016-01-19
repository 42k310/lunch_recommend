class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.integer :tblg_id

      t.timestamps
    end
  end
end
