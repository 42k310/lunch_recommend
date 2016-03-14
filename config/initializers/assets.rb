# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( questions/session.css )
Rails.application.config.assets.precompile += %w( questions/questions.css )
Rails.application.config.assets.precompile += %w( questions/answer.css )
Rails.application.config.assets.precompile += %w( questions/shops.css )
Rails.application.config.assets.precompile += %w( questions/sessions.css )

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
