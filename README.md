# Ambassador

A microservice to handle transactional emails with different by providers.


## Usage

Configuration:


```elixir
config :ambassador,
  api_adapter: {:system, "AMBASSADOR_API_ADAPTER", "Sendgrid"},
  api_options: {:system, "AMBASSADOR_API_OPTIONS", "sendgrid-token"},

config :token_auth,
  token: System.get_env("AMBASSADOR_TOKEN"),
  realm: "Authentication"
```


At this point you can send requests against Ambassador:

```sh
curl -X http://localhost:8000 -d '{"from": "noreply@example.com", "from_name": "Example company", "reply_to": "noreply@example.com", "to": "user@protonmail.com", "to_name": "User", "subject": "Welcome to product!", "text": "Thank you for joining us!"}' -H "Content-Type: application/json" -H "Authorization: Bearer your-token"
```ummy
