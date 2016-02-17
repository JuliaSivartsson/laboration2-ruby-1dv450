Rails.application.config.middleware.use OmniAuth::Builder do
    provider :github, '9ac56330fd598d093f4d', 'e77c3e6aafc80e8e80287047b028d11a377c8743'
end