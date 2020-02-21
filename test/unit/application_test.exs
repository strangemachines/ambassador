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
defmodule AmbassadorTest.Application do
  use ExUnit.Case
  import Dummy

  alias Ambassador.Application

  test "port/0" do
    dummy Confex, ["get_env/2"] do
      Application.port()
      assert called(Confex.get_env(:ambassador, :port))
    end
  end

  test "compress/0" do
    dummy Confex, ["get_env/2"] do
      Application.compress()
      assert called(Confex.get_env(:ambassador, :compress))
    end
  end

  test "the start method" do
    dummy Supervisor, ["start_link/2"] do
      dummy Application, [
        {"port", fn -> :port end},
        {"compress", fn -> :compress end}
      ] do
        Application.start(:a, :b)

        children = [
          {Plug.Cowboy,
           scheme: :http,
           plug: Ambassador.Router,
           options: [port: :port, compress: :compress]}
        ]

        assert called(Supervisor.start_link(children, strategy: :one_for_one))
      end
    end
  end
end
