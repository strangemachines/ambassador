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
#  along with this program.  If not, see <https://www.gnu.org
defmodule Ambassador.Application do
  use Application
  require Logger

  alias Ambassador.Application

  def port, do: Confex.get_env(:ambassador, :port)
  def compress, do: Confex.get_env(:ambassador, :compress)

  def start(_type, _args) do
    port = Application.port()

    children = [
      {Plug.Cowboy,
       scheme: :http,
       plug: Ambassador.Router,
       options: [port: port, compress: Application.compress()]}
    ]

    Logger.info("Starting ambassador on port #{port}")
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
