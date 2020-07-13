# gnome-terminal execs fish but $SHELL is "bash"
set -gx SHELL (which fish)

# Width for tabulations
tabs -4

# Git prompt
set -g __fish_git_prompt_show_informative_status 'yes'
set -g __fish_git_prompt_showdirtystate 'yes'
set -g __fish_git_prompt_showstashstate 'yes'
set -g __fish_git_prompt_showuntrackedfiles 'yes'
set -g __fish_git_prompt_showcolorhints 'yes'
set -g __fish_git_prompt_showupstream 'verbose name'
