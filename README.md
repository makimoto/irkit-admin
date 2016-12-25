IRKit Admin
---

A light weight web UI for IRKit.

TODO: Write them later.

## Installation

1. Get the following credentials:
  - IRKit's API client key and device ID (See http://getirkit.com/en/#IRKit-Device-API)
  - Google OAuth2's client ID and client secret (for authentication)
2. Prepare IRKit's data file and upload it to somewhere accessable from the app (such as gist.github.com)
3. Deploy the app with environemnt variables

### IRKit data file format

JSON. The key is the name of the action, and the value is the message for IRKit manipulation (response body of `GET /message`).

```json
{
  "Living Light: "{\"format\":\"raw\",\"freq\":38,\"data\":[42,0,10,20}",
  "TV": "{\"format\":\"raw\",\"freq\":38,\"data\":[100,0,42,20}"
}
```

### Environment variables

| Key | Value |
|---|---|
| `IRKIT_DATA_URI` | URI for IRKit data file |
| `IRKIT_CLIENTKEY` | Client key for IRKit |
| `IRKIT_DEVICEID` | Device ID for IRKit |
| `GOOGLE_CLIENT_ID` | Google OAuth2's client ID |
| `GOOGLE_CLIENT_SECRET` | Google OAuth2's client secret |
| `GOOGLE_HD` | Specify the domain of G Suite for Google OAuth2 |
| `SECRET_KEY_BASE` | key for crypting session cookie |
| `ALLOWED_EMAILS` | Email addresses to be allowed command execution (separated by `,`)  |

## License
MIT https://makimoto.mit-license.org/
