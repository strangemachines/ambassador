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
defmodule Ambassador do
  alias Plug.Cowboy

  alias Ambassador.Router
  require Logger

  def port, do: Confex.get_env(:ambassador, :port)
  def compress, do: Confex.get_env(:ambassador, :compress)

  def loop do
    loop()
  end

  def start(_type, _args) do
    port = Ambassador.port()

    children = [
      {Cowboy,
       scheme: :http,
       plug: Router,
       options: [port: port, compress: Ambassador.compress()]}
    ]

    Logger.info("Starting ambassador on port #{port}")
    Supervisor.start_link(children, strategy: :one_for_one)
    Ambassador.loop()
  end
end
