class CreateUsers < ActiveRecord::Migration
  def change

    create_table :users do |t|

      # メールアドレス
      t.string :email, null: false, limit: 255

      # 名前
      t.string :name,  null: false, limit: 255
      t.string :first_name, limit: 255
      t.string :last_name, limit: 255

      # 性別
      t.string :gender, limit: 255

      # イメージ
      t.string :image, limit: 255

      # 認証情報
      t.string :uid, null: false, limit: 255
      t.string :token, null: false, limit: 255
      t.string :provider, null: false, limit: 255

      t.timestamps

    end

    # ------
    # Index
    # ------

    # メールアドレスにユニーク制約を付与
    add_index :users, :email, unique: true

  end
end
