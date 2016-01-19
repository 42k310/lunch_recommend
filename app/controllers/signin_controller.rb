class SigninController < ApplicationController
  # POST /signin
  def signin

    request_url = "https://accounts.google.com"
    redirect = "https://google.com"
    res = Faraday.new(:url => request_url).get("/o/oauth2/auth?client_id=613337943808-aaajmqg3i26f7tendqb6kr9j7q9telcj.apps.googleusercontent.com&redirect_uri=#{redirect}&scope=https://www.googleapis.com/auth/drive&response_type=code&approval_prompt=force&access_type=offline")

    @oauth_info = JSON.parse(res.body)


  end
end
