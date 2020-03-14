# Anybot

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
- Change playbook.yml to identify your Digital Ocean SSH key (get it with `doctl compute ssh-key list`, for example)
- Install ansible and dotenv
- Put API key in .env as `DO_API_TOKEN=<api key>`
- Put your SSH key ID at Digital Ocean in .env like `SSH_KEYS='["12345678"]'`
- Put random values for `SECRET_KEY_BASE` and `LIVE_VIEW_SIGNING_SALT` in .env (this should be updated to not be required at build time)
- Run `dotenv ./cross-compile.sh` to build the release
- Run `dotenv ansible-playbook playbook.yml` to put it in the internet

## Need to set the following variables on Travis, or on other CI server, or in the runtime somehow

- `SECRET_KEY_BASE`
- `PORT`
- `SLACK_APP_ID`
- `SLACK_CLIENT_ID`
- `SLACK_CLIENT_SECRET`
- `SLACK_SIGNING_SECRET`
- `SLACK_BOT_TOKEN`
- `LIVE_VIEW_SIGNING_SALT`
- `GITHUB_CLIENT_ID`
- `GITHUB_CLIENT_SECRET`
- `AUTHORIZED_GITHUB_USERS`

### Deployment specific secrets

- `DO_API_TOKEN`
- `SSH_KEYS` (Example: `'["25655815","26835360"]'`)
