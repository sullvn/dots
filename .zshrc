source ~/.antigen/antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure

antigen bundle bower
antigen bundle brew
antigen bundle bundler
antigen bundle cp
antigen bundle docker
antigen bundle gem
antigen bundle git
antigen bundle git-extras
antigen bundle golang
antigen bundle npm
antigen bundle osx
antigen bundle pip
antigen bundle postgres
antigen bundle python
antigen bundle tmux
antigen bundle vi-mode
antigen bundle web-search

antigen bundle zsh-users/zsh-completions src
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply

alias vim=false
alias e=nvim

export VISUAL=nvim
export EDITOR="$VISUAL"

export GCLOUD_BIN=/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin/

export GOPATH=~/.go
export PATH=$PATH:~/.bin:$GCLOUD_BIN:$GOPATH/bin
