# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bountyhunter_session',
  :secret      => '848125c2b7d6a64d5e258e21ac182dd31373823318e9188bacc3a97198e244f8cf8fccf979e827217ed103eeb18cecf4c893de0288ef58c3cec05bfade4a22cc'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
