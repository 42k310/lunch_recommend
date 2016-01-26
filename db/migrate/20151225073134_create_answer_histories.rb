class CreateAnswerHistories < ActiveRecord::Migration
  def change

    create_table :answer_histories do |t|

      t.references :user, :null => false
      t.references :question, :null => false
      t.date :answer_date, :null => false
      t.integer :answer_type, :null => false

      t.timestamps

    end

    # ユーザーID、質問ID、回答日時の組み合わせでユニーク制約を付与
    add_index :answer_histories, [:user_id, :question_id, :answer_date], unique: true, name: "unq_ans_his_on_uid_qid_adt"

  end
end
