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
defmodule AmbassadorTest.Adapters.Sendgrid do
  use ExUnit.Case
  import Dummy

  alias Ambassador.Adapter
  alias Ambassador.Adapters.Sendgrid

  test "the parse_options function" do
    dummy Confex, ["get_env/2"] do
      assert Sendgrid.parse_options() == [[:ambassador, :api_options]]
    end
  end

  test "the token function" do
    dummy Sendgrid, [{"parse_options", fn -> [:token] end}] do
      assert Sendgrid.token() == :token
    end
  end

  test "the payload function" do
    fields = %{
      "to" => :to,
      "to_name" => :to_name,
      "from" => :from,
      "from_name" => :from_name,
      "reply_to" => :reply_to,
      "reply_to_name" => :reply_to_name,
      "subject" => :subject,
      "text" => :text
    }

    result = Sendgrid.payload(fields)
    personalizations = List.first(result[:personalizations])
    assert personalizations[:to] == [%{email: :to, name: :to_name}]
    assert result[:subject] == :subject
    assert result[:content] == [%{type: "text/plain", value: :text}]
    assert result[:from] == %{email: :from, name: :from_name}
    assert result[:reply_to] == %{email: :reply_to, name: :reply_to_name}
  end

  test "the send function" do
    headers = [{"authorization", "Bearer token"}]

    dummy Sendgrid, [
      {"token", fn -> "token" end},
      {"payload", fn _a -> :payload end},
      {"post", fn _a, _b, _c -> {:ok, :response} end}
    ] do
      assert Sendgrid.send(:fields) == :response
      assert called(Sendgrid.payload(:fields))
      assert called(Sendgrid.post("/mail/send", :payload, headers: headers))
    end
  end

  test "the send function with an error" do
    dummy Sendgrid, [
      "token/0",
      "payload/1",
      {"post", fn _a, _b, _c -> {:error, "error"} end}
    ] do
      Sendgrid.send(:fields) == %{:body => "error", :status => 400}
    end
  end

  test "the validate function" do
    dummy Adapter, [{"is_address_allowed", fn _a, _b, _c -> :result end}] do
      result = Sendgrid.validate("data")

      assert called(
               Adapter.is_address_allowed(
                 :result,
                 "reply_to",
                 :reply_to_whitelist
               )
             )

      assert result == :result
    end
  end

  test "the send_mail function" do
    data = %{"from" => :from, "to" => :to}

    dummy Sendgrid, [{"validate", {true, data}}, {"send", :send}] do
      assert Sendgrid.send_mail(data) == :send
      assert called(Sendgrid.validate(data))
      assert called(Sendgrid.send(data))
    end
  end

  test "the send_mail function with failed validation" do
    data = %{"from" => :from, "to" => :to}
    expected = %{:body => "Recipient or sender not allowed", :status => 400}

    dummy Sendgrid, [{"validate", {false, data}}] do
      assert Sendgrid.send_mail(data) == expected
    end
  end
end
