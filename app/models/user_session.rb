class UserSession < Authlogic::Session::Base
  generalize_credentials_error_messages "login not accepted"
end