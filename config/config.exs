#  Copyright (C) 2019  Jacopo Cascioli
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.
use Mix.Config

config :ambassador,
  mode: {:system, "AMBASSADOR_MODE", :transactional},
  port: {:system, :integer, "AMBASSADOR_PORT", 8000},
  compress: {:system, "AMBASSADOR_COMPRESS", true},
  api_adapter: {:system, "AMBASSADOR_API_ADAPTER", "Sendgrid"},
  api_options: {:system, "AMBASSADOR_API_OPTIONS", "api_key"},
  from_whitelist: {:system, "AMBASSADOR_FROM_WHITELIST", false},
  mail_to_whitelist: {:system, "AMBASSADOR_MAILTO_WHITELIST", false},
  reply_to_whitelist: {:system, "AMBASSADOR_REPLYTO_WHITELIST", false},
  success_uri: {:system, "AMBASSADOR_SUCCESS_URI", nil},
  error_uri: {:system, "AMBASSADOR_ERROR_URI", nil}

config :token_auth,
  token: {:system, "AMBASSADOR_TOKEN", nil},
  realm: "Authentication"

import_config "#{Mix.env()}.exs"
