# Ambassador

A microservice to handle transactional and form-based emails with different by providers.


## Usage

### Transactional

For transactional email, we will send only from a given address:


```elixir
config :ambassador,
  mode: {:system, "AMBASSADOR_MODE", :transactional},
  api_adapter: {:system, "AMBASSADOR_API_ADAPTER", "Sendgrid"},
  api_options: {:system, "AMBASSADOR_API_OPTIONS", "sendgrid-token"},
  from_whitelist: {:system, "AMBASSADOR_FROM_WHITELIST", "noreply@example.com"},
  reply_to_whitelist: {:system, "AMBASSADOR_REPLYTO_WHITELIST", "noreply@example.com"}

config :token_auth,
  token: System.get_env("AMBASSADOR_TOKEN"),
  realm: "Authentication"
```


At this point you can send requests against Ambassador:

```sh
curl -X http://localhost:8000/send -d '{"from": "noreply@example.com", "from_name": "Example company", "reply_to": "noreply@example.com", "to": "user@protonmail.com", "to_name": "User", "subject": "Welcome to product!", "text": "Thank you for joining us!"}' -H "Content-Type: application/json" -H "Authorization: Bearer your-token"
```ummy


### Form emails

In form emails, we want to send from any address to a given one. We will actually send the email from our own authorized address, and use reply_to to know who was the original sender:

```elixir
config :ambassador,
  mode: {:system, "AMBASSADOR_MODE", :form},
  api_adapter: {:system, "AMBASSADOR_API_ADAPTER", "Sendgrid"},
  api_options: {:system, "AMBASSADOR_API_OPTIONS", "sendgrid-token"},
  from_whitelist: {:system, "AMBASSADOR_FROM_WHITELIST", "hello@example.com"},
  mail_to_whitelist: {:system, "AMBASSADOR_MAILTO_WHITELIST", "hello@example.com"},
  success_uri: {:system, "AMBASSADOR_SUCCESS_URI", "https://example.com/contact-success"},
  error_uri: {:system, "AMBASSADOR_ERROR_URI", "https://example.com/contact-error"}
```


```html
<form action="http://localhost:8000/send">
    <input type="hidden" name="to" value="hello@example.com">
    <input type="hidden" name="from" value="hello@example.com">
    <input type="hidden" name="to_name" value="Example company">
    <input type="email" name="reply_to">
    <input type="text" name="reply_to_name">
    <input type="text" name="subject">
    <textarea name="text">
</form>
```
