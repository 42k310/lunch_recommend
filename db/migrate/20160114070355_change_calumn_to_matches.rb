class ChangeCalumnToMatches < ActiveRecord::Migration
  def change
    remove_column :matches, :shop_question_id
    remove_column :matches, :shop_answer_type
    add_column :matches, :shop_question1, :integer
    add_column :matches, :shop_question2, :integer
    add_column :matches, :shop_question3, :integer
    add_column :matches, :shop_question4, :integer
    add_column :matches, :shop_question5, :integer
    add_column :matches, :shop_question6, :integer
    add_column :matches, :shop_question7, :integer
  end
end
