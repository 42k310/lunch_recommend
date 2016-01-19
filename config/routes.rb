Rails.application.routes.draw do
  # resources :questions

  get "signin" => "signin#signin"

  get "questions" => "questions#index"
  post "questions" => "questions#answer"
  get "questions" => "questions#show"

  get "answer" => "questions#answer"
  post "answer" => "questions#next"
  get "answer" => "questions#has_gone"
  get "answer" => "questions#want_to_go"

end
