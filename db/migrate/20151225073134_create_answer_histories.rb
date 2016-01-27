class CreateAnswerHistories < ActiveRecord::Migration
  def change

    create_table :answer_histories do |t|

      t.references :user, :null => false
      t.references :question, :null => false
      t.date :answer_date, :null => false
      t.integer :answer_type, :null => false

      t.timestamps

    end

  end
end
