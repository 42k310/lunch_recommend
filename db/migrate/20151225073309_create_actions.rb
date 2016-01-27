class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|

      t.references :user, :null => false
      t.references :shop, :null => false
      t.integer :action_kind, :null => false

      t.timestamps

    end

    # ユーザーID、質問ID、アクション種別の組み合わせでユニーク制約を付与
    add_index :actions, [:user_id, :shop_id, :action_kind], unique: true, name: "unq_act_on_uid_sid_akd"

  end
end
