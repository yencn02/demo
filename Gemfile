source :gemcutter
source "http://gems.github.com"

gem "authlogic",            "2.1.6"                           # Authlogic gem for user authentication, session management, and persistence
gem "chronic_duration",     "0.9.2"
gem "money",                "2.2.0"                           # Money gem for handling prices stored as cent integers and currency exchanging
gem "mysql",                "2.8.1"
gem "rails",                "2.3.8"
gem "savon",                "0.7.9"                           # SOAP client
gem "searchlogic",          "2.4.14"                          # Search Logic for text searching and filtering
gem "thoughtbot-paperclip", "2.3.1", :require => "paperclip"  # Paperclip gem for file uploading, image resizing, and general file processing
gem "will_paginate",        "2.3.14"                          # Will Paginate for pagination
gem "activemerchant",       "1.7.2"
gem "carmen",               "0.1.1"
gem "geokit",               "1.5.0"
gem "fastercsv",            "1.5.1"
group :development do
  gem "mongrel",            "1.1.5"
  gem "ruby-debug"
  gem "sqlite3-ruby",       "1.3.0",    :require => "sqlite3"
end


group :test do
  gem "rcov"
  gem "cucumber-rails",           "0.3.2"
  gem "rspec",                    "1.3.0"
  gem "rspec-rails",              "1.3.2"
  gem "spork",                    "0.8.4"
  gem "test-unit",                "1.2.3"
  gem "thoughtbot-factory_girl",  ">=1.2.2",    :require => "factory_girl"
end

group :cucumber do
  gem "thoughtbot-factory_girl",  ">=1.2.2",    :require => "factory_girl"
  gem "capybara",                 "0.3.0"
  gem "database_cleaner",         "0.5.0"
  gem "configuration",            "1.1.0"
  gem "launchy",                  "0.3.7"
end
