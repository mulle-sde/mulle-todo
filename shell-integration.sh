#!/bin/bash
#
# Example shell integration for mulle-todo
#
# Add this to your ~/.bashrc or ~/.zshrc to display todos on login
#

# Display todo list when opening a new shell
if command -v mulle-todo >/dev/null 2>&1; then
    # Option 1: Show formatted output with decorative borders (like motd)
    # Limited to 8 items (top 3 + 5 random)
    mulle-todo show 8 2>/dev/null
    
    # Option 2: Show plain list (commented out, uncomment to use instead)
    # mulle-todo list 10 2>/dev/null
fi

# Optional: Add convenient aliases
alias todo='mulle-todo'
alias t='mulle-todo list'
alias ta='mulle-todo add'
alias tr='mulle-todo remove'
alias tu='mulle-todo up'
alias td='mulle-todo down'
alias tc='mulle-todo clear'
