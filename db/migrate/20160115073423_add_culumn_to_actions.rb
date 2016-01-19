class AddCulumnToActions < ActiveRecord::Migration
  def change
    add_column :actions, :shop_id, :integer
    add_column :actions, :user_id, :integer
  end
end
