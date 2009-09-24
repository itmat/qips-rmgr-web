# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_aws_app_session',
  :secret      => 'caa7b2937aa2e2fd3749f8426550b6cd662ab62a770e6555699dd6e4eaf216aaf24f614be6cc94a21546c1a66b475635cb2f75fd8fe36abe82babb6186653dd1'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
