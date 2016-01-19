class CreateAnswerHistories < ActiveRecord::Migration
  def change
    create_table :answer_histories do |t|
      t.date :answer_date
      t.text :answer_type

      t.timestamps
    end
  end
end
