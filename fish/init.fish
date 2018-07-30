set -gx SHELL (which fish)

# Git prompt
set -g __fish_git_prompt_show_informative_status 'yes'
set -g __fish_git_prompt_showdirtystate 'yes'
set -g __fish_git_prompt_showstashstate 'yes'
set -g __fish_git_prompt_showuntrackedfiles 'yes'
set -g __fish_git_prompt_showcolorhints 'yes'
set -g __fish_git_prompt_showupstream 'verbose name'

# Width for tabulations
tabs -4


### Oh-my-fish ###

# bobthefish theme
#set -g theme_display_user yes
set -g default_user damien # implies theme_display_user
set -g theme_display_cmd_duration yes
set -g theme_show_exit_status yes
set -g theme_title_display_process yes
set -g theme_date_format "+%R %a %d/%m/%y"
set -g theme_display_git_ahead_verbose yes
set -g theme_git_worktree_support yes

# GRC plugin
set -g grcplugin_ls --color


### Python ###

# VirtualEnv
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

# PyEnv
status --is-interactive; and source (pyenv init -|psub)
status --is-interactive; and source (pyenv virtualenv-init -|psub)
