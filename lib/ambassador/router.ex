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
defmodule Ambassador.Router do
  alias Ambassador.Handler
  alias Ambassador.Log

  use Plug.Router

  @token Confex.get_env(:token_auth, :token)

  if @token do
    plug(TokenAuth)
  end

  plug(Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Jason)
  plug(:match)
  plug(:dispatch)

  post "/" do
    Log.processing(conn)
    Handler.transactional(conn)
  end

  match(
    _,
    do:
      Handler.send_json(conn, 404, %{
        :message => "The requested resource does not exist"
      })
  )
end
