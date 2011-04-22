# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ln_members_session',
  :secret      => '9086337cd5dbfb846ec2043c0e7e572c9157c50b98bb97f4e755fc11cd6dabb8722c23a435462f60350510e604030f5b935cc569c22c1abdd5ddbdbcec7a7f39'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
