Rails.application.routes.draw do
  # resources :questions

  root :to => "questions#index"

  get "signin" => "signin#signin"

  get "questions" => "questions#index"
  post "answer" => "questions#answer"
  get "answer" => "questions#answer"
  post "next" => "questions#next"
  get "next" => "questions#next"
  post "want_to_go" => "questions#want_to_go"
  get "want_to_go" => "questions#want_to_go"
  post "has_gone" => "questions#has_gone"
  get "has_gone" => "questions#has_gone"

  # post "questions" => "questions#answer"
  # get "questions" => "questions#show"
  #
  # get "answer" => "questions#answer"
  # post "answer" => "questions#next"
  # get "answer" => "questions#has_gone"
  # get "answer" => "questions#want_to_go"

end
