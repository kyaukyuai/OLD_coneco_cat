Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.production?
    provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], info_fields: 'name,email'
  else
    provider :facebook, "909445219133714", "db5173990b73e8dc88f4709d2f28f98a", info_fields: 'name,email'
  end
end
