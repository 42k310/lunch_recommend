Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Settings.google_api.client_id, Settings.google_api.client_secret, :skip_jwt => true
end
OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}