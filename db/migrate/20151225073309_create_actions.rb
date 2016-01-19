class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.integer :action_kind

      t.timestamps
    end
  end
end
