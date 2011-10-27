#Load authorize config
authorize = YAML.load_file("#{RAILS_ROOT}/config/authorize.yml")
LOGIN_ID = authorize[RAILS_ENV]["login_id"]
TRANSACTION_KEY = authorize[RAILS_ENV]["transaction_key"]

#Load lime_light config
lime_light = YAML.load_file("#{RAILS_ROOT}/config/limelight.yml")
SECRET_KEY = lime_light[RAILS_ENV]["secret_key"]
URL_STORE = lime_light[RAILS_ENV]["url_store"]
URL_DEMO = lime_light[RAILS_ENV]["url_demo"]

#Load acutrack config
acutrack = YAML.load_file("#{RAILS_ROOT}/config/acutrack.yml")
DEALER_ID = acutrack[RAILS_ENV]["dealer_id"]
DEALER_PASSWORD = acutrack[RAILS_ENV]["dealer_password"]
TOKEN_KEY = acutrack[RAILS_ENV]["token_key"]
LIVE_TRANSACTION = acutrack[RAILS_ENV]["live_transaction"]
ORDER_CONFIRM_URL = acutrack[RAILS_ENV]["order_notification_url"]
DOMESTIC_SHIPPING = acutrack[RAILS_ENV]["shipping_type"]["domestic"]
INTERNATIONAL_SHIPPING = acutrack[RAILS_ENV]["shipping_type"]["international"]
SHIPPING_CAREER = {
  4 => "USPS First Class with tracking",
  32 => "USPS  First Class No Tracking",
  7 => "USPS Priority",
  8 => "USPS Express",
  6 => "USPS  International First Class",
  10 => "USPS International Priority",
  17 => "USPS  International Express",
  33 => "FedEx Ground",
  42 => "FedEx 2 Day",
  44 => "FedEx Standard Overnight",
  39 => "FedEx International Economy",
  45 => "FedEx International Ground",
  15 => "UPS Ground",
  14 => "UPS 2nd Day Air",
  13 => "UPS Next Day Air",
  19 => "UPS Canada standard",
  16 => "UPS World Wide Expedited"
}


host = YAML.load_file("#{RAILS_ROOT}/config/host.yml")
HOST_URL = host["host_url"]
NOTIFY_EMAIL = host["notify_email"]


BG_DIRECTORY = "public/system/background_images"
BG_DEFAULT = "background"
BG_IPAD = "background-ipad"