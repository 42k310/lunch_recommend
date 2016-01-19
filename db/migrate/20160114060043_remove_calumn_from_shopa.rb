class RemoveCalumnFromShopa < ActiveRecord::Migration
  def change
    remove_column :shops, :shop_answer_type
    remove_column :shops, :question_id
  end
end
