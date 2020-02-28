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
defmodule AmbassadorTest.Adapters.Mock do
  use ExUnit.Case

  alias Ambassador.Adapters.Mock

  test "parse_options/0" do
    assert Mock.parse_options() == []
  end

  test "payload" do
    assert Mock.payload(:fields) == %{}
  end

  test "send_mail/1" do
    assert Mock.send_mail(%{}) == %{:body => "json", :status => 202}
  end
end
