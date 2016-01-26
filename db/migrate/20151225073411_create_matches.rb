class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|

      t.references :shop, :null => false
      t.references :question, :null => false
      t.integer :answer_type, :null => false

      t.timestamps

    end

    # ユーザーID、質問ID、回答種別の組み合わせでユニーク制約を付与
    add_index :matches, [:shop_id, :question_id, :answer_type], unique: true, name: "unq_mtc_on_uid_qid_atp"

  end
end
