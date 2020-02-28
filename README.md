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
