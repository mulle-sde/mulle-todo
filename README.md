# mulle-todo

## Features

- ✨ **Beautiful box-drawn interface** with colors and emojis
- 📝 **Simple commands** - add, remove, reorder tasks
- 🎯 **Smart truncation** - top 3 items stay visible, rest rotate randomly
- 🚀 **Shell integration** - display on login like motd
- 💾 **Plain text storage** - easy to backup and sync
- 🧪 **Comprehensive test suite** - 41 tests covering all functionality

## Installation

Copy `mulle-todo` to somewhere in your PATH, for example:

```bash
sudo cp mulle-todo /usr/local/bin/
sudo chmod +x /usr/local/bin/mulle-todo
```

## Usage

### Commands

- `mulle-todo add <text>` - Add a new todo item
- `mulle-todo list [n]` - Display all (or n) todo items (default command)
- `mulle-todo show [n]` - Display todos in a nice formatted box (for shell login)
- `mulle-todo remove <number>` - Remove a todo item by its number
- `mulle-todo remove-all` - Remove all todo items (alias: `clear`)
- `mulle-todo up <number>` - Move an item up in the list
- `mulle-todo down <number>` - Move an item down in the list

### Options

- `--file <path>` - Use a custom todo file instead of the default location

**Note on truncation:** When listing with a limit `[n]`, the top 3 items stay in order, and the remaining items are randomly selected. This ensures you don't lose sight of any todo item over time, as different items will appear each time you view the list.

### Examples

```bash
# Add some todos
mulle-todo add "Fix the login bug"
mulle-todo add "Write documentation"
mulle-todo add "Review pull requests"

# Use with emojis for better visual organization
mulle-todo add "🔥 Fix critical bug"
mulle-todo add "📝 Update docs"
mulle-todo add "🚀 Deploy to prod"

# List all todos
mulle-todo list
# Output:
#   1. Fix the login bug
#   2. Write documentation
#   3. Review pull requests

# List only 6 items (top 3 + 3 random from remaining)
mulle-todo list 6

# Move item 3 up
mulle-todo up 3
# Output:
#   1. Fix the login bug
#   2. Review pull requests
#   3. Write documentation

# Remove item 2
mulle-todo remove 2

# Show formatted output (like motd) with max 5 items
mulle-todo show 5

# Remove all items
mulle-todo remove-all
# or
mulle-todo clear

# Use custom file (useful for testing or multiple lists)
mulle-todo --file ~/work-todos.txt add "Finish project"
mulle-todo --file ~/personal-todos.txt add "Buy groceries"
```

## Shell Integration

To display your todo list when you log into a shell (like `~/.motd`), add this to your `~/.bashrc` or `~/.zshrc`:

```bash
# Display todo list on login (limit to 8 items)
if command -v mulle-todo >/dev/null 2>&1; then
    mulle-todo show 8
fi
```

Or for a more compact version without the decorative lines:

```bash
# Display todo list on login (limit to 10 items)
if command -v mulle-todo >/dev/null 2>&1; then
    mulle-todo list 10 2>/dev/null
fi
```

You can also source the provided `shell-integration.sh` file:

```bash
# Add to ~/.bashrc or ~/.zshrc
source /path/to/mulle-todo/shell-integration.sh
```

## Smart Truncation

When you have more todos than the display limit, `mulle-todo` uses a smart algorithm:
- **Top 3 items always stay in order** - Your most important tasks remain visible
- **Remaining slots are randomly filled** - Each time you check, different items appear
- This prevents any todo from being "hidden forever" at the bottom of a long list

Example with 10 items, showing 6:
```
First view:    1, 2, 3, 9, 7, 5
Second view:   1, 2, 3, 4, 10, 8
Third view:    1, 2, 3, 6, 7, 9
```

## Storage

Todo items are stored in `~/.mulle/etc/todo/todo.txt`

## Testing

The project includes a comprehensive test suite in the `test/` directory:

```bash
cd test
./run-all-tests.sh
```

Tests use isolated temporary files via the `--file` flag, so they won't touch your actual todo list.

See [test/README.md](test/README.md) for more details on running individual test suites.

## License

See the license header in the `mulle-todo` script.
