class RemoveCalumnFromMatches < ActiveRecord::Migration
  def change
    remove_column :matches, :answer_type
  end
end
