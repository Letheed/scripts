# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

### GO
export GOROOT=/usr/lib/go
#export GOPATH=$HOME/go
#export GOBIN=$GOPATH/bin

### .NET
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export FrameworkPathOverride=/usr/lib/mono/4.5/

### GTAGS
#export GTAGSLABEL="ctags"
#export GTAGSCONF="$HOME/.globalrc"
#export GTAGSLIBPATH="$HOME/.gtags"

### PATH
export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin
export PATH=$PATH:/home/linuxbrew/.linuxbrew/sbin
export PATH=$HOME/.gem/ruby/default/bin:$PATH
export PATH=$HOME/go/bin:$PATH
export PATH=$HOME/.pyenv/bin:$PATH
export PATH=$HOME/.nimble/bin:$PATH
export PATH=$HOME/.cabal/bin:$PATH
export PATH=$HOME/.stack/programs/x86_64-linux/default/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

### MANPATH
export MANPATH=$MANPATH:/home/linuxbrew/.linuxbrew/share/man

### INFOPATH
export INFOPATH=$INFOPATH:/home/linuxbrew/.linuxbrew/share/info
