class AddCollumnstoShops < ActiveRecord::Migration
  def change
    add_column :shops, :shop_answer_type, :integer
    add_column :shops, :question_id, :integer
  end
end
