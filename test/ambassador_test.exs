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
defmodule AmbassadorTest do
  use ExUnit.Case
  import Dummy

  test "the port method" do
    dummy Confex, ["get_env/2"] do
      Ambassador.port()
      assert called(Confex.get_env(:ambassador, :port))
    end
  end

  test "the compress method" do
    dummy Confex, ["get_env/2"] do
      Ambassador.compress()
      assert called(Confex.get_env(:ambassador, :compress))
    end
  end

  test "loop" do
    dummy Ambassador, [{"loop", fn -> :loop end}] do
      assert Ambassador.loop() == :loop
    end
  end

  test "the start method" do
    dummy Supervisor, ["start_link/2"] do
      dummy Ambassador, [
        {"port", fn -> :port end},
        {"compress", fn -> :compress end},
        {"loop", fn -> :loop end}
      ] do
        Ambassador.start(:a, :b)

        children = [
          {Plug.Cowboy,
           scheme: :http,
           plug: Ambassador.Router,
           options: [port: :port, compress: :compress]}
        ]

        assert called(Supervisor.start_link(children, strategy: :one_for_one))
        assert called(Ambassador.loop())
      end
    end
  end
end
