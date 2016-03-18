Rails.application.routes.draw do

  # ------------
  # トップ
  # ------------

  # 質問画面へ飛ばす
  root :to => "questions#index"

  # ------------
  # 認証
  # ------------

  # サインイン
  get "/signin" => "sessions#show"
  get "/signout" => "sessions#destroy"

  # コールバック
  get  '/auth/:provider/callback' => 'sessions#callback'
  post '/auth/:provider/callback'  => 'sessions#callback'
  # 認証失敗
  get  '/auth/failure' => 'sessions#failure'

  # ------------
  # 質問・回答
  # ------------

  # 質問画面
  get "questions" => "questions#index"

  # 回答画面
  post "answer" => "questions#answer"
  get "answer" => "questions#answer"

  # 次へ
  post "next" => "questions#next"
  get "next" => "questions#next"

  # 行きたい
  get "want_to_go" => "questions#want_to_go"
  post "want_to_go" => "questions#want_to_go"

  # 行った
  get "has_gone"  => "questions#has_gone"
  post "has_gone"  => "questions#has_gone"

  # お気に入り
  post "favorite" => "questions#favorite"
  get "favorite" => "questions#favorite"

  # レコメンドする店舗がないとき
  get "error" => "questions#nothing"
  post "error" => "questions#nothing"

  # 最初からやり直す
  get "retry" => "questions#retry"
  post "retry" => "questions#retry"

  # エラーページへ飛ばす
  # get "/404" => "errors/error404"
  # get "/500" => "errors/error_500"

end
