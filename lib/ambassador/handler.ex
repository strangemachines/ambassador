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
defmodule Ambassador.Handler do
  alias Ambassador.Handler
  alias Ambassador.Log
  alias Plug.Conn

  @adapter Confex.get_env(:ambassador, :api_adapter)
  @mail String.to_existing_atom("Elixir.Ambassador.Adapters.#{@adapter}")
  @error_uri Confex.get_env(:ambassador, :error_uri)
  @success_uri Confex.get_env(:ambassador, :success_uri)

  def send_json(conn, status, payload) do
    conn
    |> Conn.put_resp_content_type("application/json")
    |> Conn.send_resp(status, Jason.encode!(payload))
  end

  def send_to_other(conn, location) do
    conn
    |> Conn.put_resp_header("location", location)
    |> Conn.send_resp(303, [])
  end

  def form(conn) do
    response = @mail.send_mail(conn.body_params)
    Log.processed(response)

    case response do
      %{:status => 200} -> Handler.send_to_other(conn, @success_uri)
      _ -> Handler.send_to_other(conn, @error_uri)
    end
  end

  def transactional(conn) do
    response = @mail.send_mail(conn.body_params)
    Log.processed(response)
    Handler.send_json(conn, response.status, response.body)
  end
end
