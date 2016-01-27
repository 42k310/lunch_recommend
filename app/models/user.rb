class User < ActiveRecord::Base

  protected

  def self.find_or_create_user(auth)

    # メールアドレスからユーザー情報を検索
    user = User.find_by(email: auth.info.email)

    # ユーザーが存在しない場合
    unless user
      # 新規ユーザー登録
      user = User.create(
        email:  auth.info.email,
        name: auth.info.name,
        first_name: auth.info.first_name,
        last_name: auth.info.last_name,
        gender:auth.extra.raw_info.gender,
        image: auth.info.image,
        uid: auth.uid,
        token: auth.credentials.token,
        provider: auth.provider
      )
    end

    # ユーザー情報を返却
    user

  end

end
