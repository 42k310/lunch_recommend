class User < ActiveRecord::Base

  # OAuth認証、トラック
  devise :trackable, :omniauthable

  protected

  def self.find_for_google(auth)

    # メールアドレスからユーザー情報を検索
    user = User.find_by(email: auth.info.email)

    # ユーザーが存在しない場合
    unless user
      # 新規ユーザー登録
      user = User.create(
        name: auth.info.name,
        email:  auth.info.email,
        provider: auth.provider,
        uid: auth.uid,
        token: auth.credentials.token,
        meta: auth.to_yaml)
    end

    # ユーザー情報を返却
    user

  end

end
