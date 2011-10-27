# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_vafitness_session',
  :secret      => '53asd324c263c96b7aa293c05df78c00a98627320a617ef1d22acec003203037ae2fcd4d112c6ab3d67d622568207404217dcd1a253028d72d1c28a41c8136d5946aa4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
