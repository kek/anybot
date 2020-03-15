# Slack bot that runs Luerl programs

## API available to programs

## `require(program)`

Load another program's code.

## `get(<url>)`

Retrieve resource at an URL. Text of response can be retrieved like so: `get(url)["body"]`.

## `decode(<data>)`

Decode a string of JSON data. Example: `decode(get("http://example.com/example.json")["body"])`

## `post(url, data)` (planned)

## Commands for bots

### `!save <name> <program>`

Save a program.

### `!delete <name>`

Removes a program.

### `!list`

List saved programs.

### `!show <name>`

Shows the code for a saved program.

### `!help`

Display help for these commands.

## Deploying to Digital Ocean

- Create SSH key in Digital Ocean
- Create API key (https://cloud.digitalocean.com/account/api/tokens)
- Fork this project
- Install ansible and dotenv
- Set the below environment variables in .env
- Put random values for `SECRET_KEY_BASE` and `LIVE_VIEW_SIGNING_SALT` in .env (this should be updated to not be required at build time)
- Run `dotenv ./cross-compile.sh` to build the release
- Run `dotenv ansible-playbook playbook.yml` to put it in the internet
- Connect a domain name
- Log in and run certbot --nginx
- Manually disable the nginx site "default" and enable the site "bot"

## Need to set the following variables on Travis, or on other CI server, or in the runtime somehow

- `SECRET_KEY_BASE` (generate a random secure value)
- `LIVE_VIEW_SIGNING_SALT` (generate a random secure value)
- `WEB_SERVER_HOST` (the domain name that the app runs on)

### Get these from Slack:

- `SLACK_APP_ID`
- `SLACK_CLIENT_ID`
- `SLACK_CLIENT_SECRET`
- `SLACK_SIGNING_SECRET`
- `SLACK_BOT_TOKEN`

### Get these from GitHub:

- `GITHUB_CLIENT_ID`
- `GITHUB_CLIENT_SECRET`
- `AUTHORIZED_GITHUB_USERS` (list of GitHub usernames that will have access to the web UI)

### Deployment specific secrets

- `DO_API_TOKEN` (Digital Ocean token that has access to provision an instance)
- `SSH_KEYS` (Example: `'["1000001","1000002"]'`. Get them with `doctl compute ssh-key list`)
