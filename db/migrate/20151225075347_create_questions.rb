class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|

      t.string :title, null: false, limit: 100
      t.text :answer1, null: false, limit: 50
      t.text :answer2, null: false, limit: 50

      t.timestamps
    end
  end
end
