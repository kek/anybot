# Anybot

## API available to bots

## `get(<url>)`

Retrieve resource at an URL. Text of response can be retrieved like so: `get(url)["body"]`.

## `decode(<data>)`

Decode a string of JSON data. Example: `decode(get("http://example.com/example.json")["body"])`

## `post(url, data)` (planned)

## Persistence commands (planned)

### `!save <name> <program>`
Save a program and run it. The code will be run again at restart.

### `!delete <name>`
Removes a program so that it won't be run at next restart.

### `!list`
List saved programs.

### `!show <name>`
Shows the code for a saved program.

### `!help`
Display help for these commands.
