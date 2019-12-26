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
defmodule Ambassador.Adapter do
  @moduledoc """
  Utitlies for building adapters
  """
  alias Ambassador.Adapter

  def is_mail_allowed?(whitelist, mail_address) do
    if whitelist == false do
      true
    else
      whitelist
      |> String.split(":")
      |> Enum.find(false, fn x -> x == mail_address end)
      |> (fn result -> if result == false, do: false, else: true end).()
    end
  end

  def is_address_allowed({status, data}, key, whitelist) do
    if status == true do
      whitelist = Confex.get_env(:ambassador, whitelist)
      status = Adapter.is_mail_allowed?(whitelist, data[key])
      {status, data}
    else
      {status, data}
    end
  end
end
