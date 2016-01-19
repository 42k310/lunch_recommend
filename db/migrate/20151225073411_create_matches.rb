class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :answer_type

      t.timestamps
    end
  end
end
