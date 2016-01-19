class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :title
      t.text :answer1
      t.text :answer2

      t.timestamps
    end
  end
end
