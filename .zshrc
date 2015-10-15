source ~/.antigen/antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle bower
antigen bundle brew
antigen bundle gem
antigen bundle git-extras
antigen bundle golang
antigen bundle npm
antigen bundle osx
antigen bundle pip
antigen bundle postgres
antigen bundle vi-mode
antigen bundle web-search

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search

antigen theme sorin
antigen apply

alias e=nvim
export EDITOR=nvim
export VISUAL="$EDITOR"

export GOPATH=~/.go
export PATH=/usr/local/bin:~/.bin:$PATH:$GOPATH/bin

cd() { 
    builtin cd "$@" && ls
}
