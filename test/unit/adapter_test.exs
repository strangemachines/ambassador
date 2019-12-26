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
defmodule AmbassadorTest.Adapter do
  use ExUnit.Case
  import Dummy

  alias Ambassador.Adapter

  test "the is_mail_allowed? function" do
    assert Adapter.is_mail_allowed?(false, "mail") == true
  end

  test "the is_mail_allowed? function with a failing whitelist" do
    assert Adapter.is_mail_allowed?("white:list", "mail") == false
  end

  test "the is_mail_allowed? function with a successful whitelist" do
    assert Adapter.is_mail_allowed?("mail:list", "mail") == true
  end

  test "the is_address_allowed function" do
    data = %{"key" => "value"}

    dummy Confex, [{"get_env", fn _a, _b -> :whitelist end}] do
      dummy Adapter, [{"is_mail_allowed?", fn _a, _b -> true end}] do
        result = Adapter.is_address_allowed({true, data}, "key", :whitelist)
        assert called(Confex.get_env(:ambassador, :whitelist))
        assert called(Adapter.is_mail_allowed?(:whitelist, "value"))
        assert result == {true, data}
      end
    end
  end

  test "the is_address_allowed function with false" do
    result = Adapter.is_address_allowed({false, :data}, :key, :whitelist)
    assert result == {false, :data}
  end
end
