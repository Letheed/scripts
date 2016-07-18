function valgrind
	command valgrind --track-origins=yes --show-leak-kinds=all --leak-check=full $argv
end