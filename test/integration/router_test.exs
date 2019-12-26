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
defmodule AmbassadorTest.Router do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Ambassador.Router

  @expected_headers ["application/json; charset=utf-8"]

  test "sending an email" do
    response =
      conn(:post, "/send")
      |> put_req_header("authorization", "Bearer token")
      |> Router.call([])

    assert response.status == 202
    assert get_resp_header(response, "content-type") == @expected_headers
    assert response.resp_body == "\"json\""
  end

  test "returning a 404 for unmatched routes" do
    message = "{\"message\":\"The requested resource does not exist\"}"

    response =
      conn(:get, "/whatever")
      |> put_req_header("authorization", "Bearer token")
      |> Router.call([])

    assert response.status == 404
    assert get_resp_header(response, "content-type") == @expected_headers
    assert response.resp_body == message
  end
end
