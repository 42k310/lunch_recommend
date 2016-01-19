class AddColumAnswerHistories < ActiveRecord::Migration
  def change
    add_column :answer_histories, :question_id, :integer
    add_column :answer_histories, :user_id, :integer
  end
end
