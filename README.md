# 📋 A Todo list manager for shell environments

... for Android, BSDs, Linux, macOS, SunOS, Windows (MinGW, WSL)

A simple but elegant todo list manager that displays on shell login
(like motd) with beautiful Unicode box drawing, emoji support, and smart
features.

![Screenshot](screeny.png?raw=true)


<!--
**Key Features:**

* ✨ Beautiful box-drawn interface with colors and emojis
* 📝 Simple commands - add, remove, reorder tasks
* 🎯 Smart truncation - top 3 items stay visible, rest rotate randomly
* 🚀 Shell integration - display on login like motd
* 💾 Plain text storage - easy to backup and sync
* 🧪 Comprehensive test suite - 41 tests covering all functionality
-->
| Release Version                                       | Release Notes
|-------------------------------------------------------|--------------
| ![Mulle kybernetiK tag](https://img.shields.io/github/tag/mulle-sde/mulle-todo.svg)  | [RELEASENOTES](RELEASENOTES.md) |





## Usage

### Commands

- `mulle-todo add <text>` - Add a new todo item
- `mulle-todo list [n]` - Display all (or n) todo items
- `mulle-todo show [n]` - Display todos in a nice formatted box (default command)
- `mulle-todo remove <number>` - Remove a todo item by its number
- `mulle-todo remove-all` - Remove all todo items (alias: `clear`)
- `mulle-todo up <number>` - Move an item up in the list
- `mulle-todo down <number>` - Move an item down in the list
- `mulle-todo scan` - Scan source files for TODO comments (experimental)
- `mulle-todo scan-import` - Import scanned TODOs into your list (experimental)
- `mulle-todo install-shell-integration` - Install shell integration into your shell profile

### Options

- `--file <path>` - Use a custom todo file instead of the default location
- `-g, --global` - Force use of global file (~/.mulle/etc/todo/todo.txt)

### File Location Logic

By default, `mulle-todo` uses **project-local** todos when available:

1. **Local project**: If `.mulle/etc/` exists in current directory → `./.mulle/etc/todo/todo.txt`
2. **Global**: Otherwise → `~/.mulle/etc/todo/todo.txt`
3. **Override**: Use `-g/--global` to force global location, or `--file <path>` for custom location

This allows you to have per-project todos while still maintaining a global todo list.

**Note on truncation:** When listing with a limit `[n]`, the top 3 items stay in order, and the remaining items are randomly selected. This ensures you don't lose sight of any todo item over time, as different items will appear each time you view the list.

### Examples

```bash
# Add some todos (uses local .mulle/etc/todo/todo.txt if it exists)
mulle-todo add "Fix the login bug"
mulle-todo add "Write documentation"
mulle-todo add "Review pull requests"

# Use with emojis for better visual organization
mulle-todo add "🔥 Fix critical bug"
mulle-todo add "📝 Update docs"
mulle-todo add "🚀 Deploy to prod"

# Show todos (default command)
mulle-todo
# or explicitly
mulle-todo show

# List todos in plain format
mulle-todo list

# List only 6 items (top 3 + 3 random from remaining)
mulle-todo list 6

# Move item 3 up
mulle-todo up 3

# Remove item 2
mulle-todo remove 2

# Show formatted output with max 5 items
mulle-todo show 5

# Remove all items
mulle-todo remove-all
# or
mulle-todo clear

# Use global todo list (even if in a project directory)
mulle-todo -g add "Personal task"
mulle-todo -g show

# Use custom file (useful for testing or multiple lists)
mulle-todo --file ~/work-todos.txt add "Finish project"
mulle-todo --file ~/personal-todos.txt add "Buy groceries"
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

Todo items are stored in plain text files:

- **Project-local**: `./.mulle/etc/todo/todo.txt` (if `.mulle/etc/` directory exists)
- **Global**: `~/.mulle/etc/todo/todo.txt` (default fallback)

Use `-g/--global` flag to force global location, or `--file <path>` for custom locations.

## Testing

The project includes a comprehensive test suite in the `test/` directory:

```bash
cd test
./run-all-tests.sh
```

Tests use isolated temporary files via the `--file` flag, so they won't touch your actual todo list.

See [test/README.md](test/README.md) for more details on running individual test suites.






## Installation

Grab `mulle-todo` from the [release assets](https://github.com/mulle-sde/mulle-menu/releases/tag/latest)
and copy it to somewhere in your PATH:

```bash
sudo cp mulle-todo /usr/local/bin/
sudo chmod +x /usr/local/bin/mulle-todo
```


### Quick Setup (Recommended)

The easiest way to set up shell integration is to use the built-in installer:

```bash
mulle-todo install-shell-integration
```

This will automatically:
- Detect your shell (bash/zsh) and platform (Linux/macOS)
- Add the integration code to the appropriate file (~/.bashrc, ~/.zshrc, or ~/.bash_profile)
- Create a backup of your existing shell configuration
- Display todos on every new shell session (limited to 8 items)

### Manual Setup

If you prefer to set it up manually, add this to your `~/.bashrc` or `~/.zshrc`:

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

## Author

[Nat!](https://mulle-kybernetik.com/weblog) for Mulle kybernetiK


![footer](https://www.mulle-kybernetik.com/pix/heartlessly-vibecoded.png)
