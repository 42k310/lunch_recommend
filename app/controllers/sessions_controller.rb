class SessionsController < ApplicationController

  # ログイン画面表示
  def show
    p "-----------------------------"
    p "SessionsController - show"
    p "-----------------------------"
    # ログイン画面を表示
  end

  # ログアウト
  def destroy

    p "-----------------------------"
    p "SessionsController - destroy"
    p "-----------------------------"

    # セッションをクリア
    session.clear
    # サインイン画面へ
    redirect_to signin_path

  end

  # コールバック
  def callback

    p "-----------------------------"
    p "SessionsController - callback"
    p "-----------------------------"

    # ユーザー情報取得
    auth = request.env['omniauth.auth']

    p "auth.info.email: #{auth.info.email}"
    p "auth.info.name: #{auth.info.name}"
    p "auth.info.first_name: #{auth.info.first_name}"
    p "auth.info.last_name: #{auth.info.last_name}"
    p "auth.info.image: #{auth.info.image}"
    p "auth.extra.raw_info.gender: #{auth.extra.raw_info.gender}"
    p "auth.uid: #{auth.uid}"
    p "auth.credentials.token: #{auth.credentials.token}"
    p "auth.provider: #{auth.provider}"

    p "-----------------------------"


    # ユーザー情報取得（存在しない場合は新規作成して取得）
    user = User.find_or_create_user(auth)

    if user.present?
      # ユーザーIDをセッション情報に格納
      session[:user_id] = user.id
      # ユーザー情報取得に成功した場合は質問画面へ
      redirect_to questions_path
    else
      # ユーザー情報取得に失敗した場合はログイン画面へ
      redirect_to signin_path
    end

  end

  ## 認証失敗
  def failure
    p "-----------------------------"
    p 'SessionsController - failure'
    p "-----------------------------"
    redirect_to signin_path
  end

end