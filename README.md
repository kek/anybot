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
- Put random values for `SECRET_KEY_BASE` and `LIVE_VIEW_SIGNING_SALT` in .env (this should be updated to not be required at build time)
- Run `dotenv ./cross-compile.sh` to build the release
- Run `dotenv ansible-playbook playbook.yml` to put it in the internet
