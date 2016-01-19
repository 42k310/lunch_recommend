class AddCalumnToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :shop_question_id, :integer
    add_column :matches, :shop_answer_type, :integer
  end
end
