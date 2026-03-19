mulle-todo:	mulle-todo.in
	chmod +w "$@"
	mulle-bashfunctions embed < $< > $@
	chmod -w "$@"
