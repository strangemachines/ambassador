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
defmodule Ambassador.Log do
  require Logger

  def processing(conn) do
    from = conn.body_params["from"]
    to = conn.body_params["to"]
    subject = conn.body_params["subject"]
    Logger.info("Processing submission from #{from} to #{to} about #{subject}")
  end

  def processed(response) do
    Logger.info("Processed submission with status #{response.status}")
  end
end
