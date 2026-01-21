# -- Formula Info --
# If you don't have this file, there will be no homebrew
# formula operations.
#
PROJECT="mulle-todo"      # your project/repository name
DESC="📋 A Todo list manager for shell environment"
LANGUAGE="bash"                # c,cpp, objc, bash ...
# NAME="${PROJECT}"        # formula filename without .rb extension

DEPENDENCIES='${MULLE_NAT_TAP}mulle-bashfunctions
'

DEBIAN_DEPENDENCIES="mulle-bashfunctions (>= 7.0.0)"

