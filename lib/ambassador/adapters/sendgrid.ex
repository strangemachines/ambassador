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
defmodule Ambassador.Adapters.Sendgrid do
  @behaviour Ambassador.Adapters.Mail
  use Tesla
  alias Ambassador.Adapters.Sendgrid

  plug(Tesla.Middleware.BaseUrl, "https://api.sendgrid.com/v3")
  plug(Tesla.Middleware.JSON)

  @impl true
  def parse_options(), do: [Confex.get_env(:ambassador, :api_options)]

  def token(), do: Sendgrid.parse_options() |> List.first()

  @impl true
  def payload(fields) do
    payload = %{
      :personalizations => [
        %{:to => [%{:email => fields["to"], :name => fields["to_name"]}]}
      ],
      :subject => fields["subject"],
      :content => [%{:type => "text/plain", :value => fields["text"]}],
      :from => %{:email => fields["from"], :name => fields["from_name"]}
    }

    if fields["reply_to"] do
      Map.put(payload, :reply_to, %{
        :email => fields["reply_to"],
        :name => fields["reply_to_name"]
      })
    else
      payload
    end
  end

  def send(fields) do
    headers = [{"authorization", "Bearer #{Sendgrid.token()}"}]
    payload = Sendgrid.payload(fields)

    case Sendgrid.post("/mail/send", payload, headers: headers) do
      {:ok, response} -> response
      {:error, error} -> %{:body => error, :status => 400}
    end
  end

  @impl true
  def send_mail(data) do
    Sendgrid.send(data)
  end
end
