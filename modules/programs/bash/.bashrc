[[ $- == *i* ]] && source -- @bleshPath@ --attach=none

set -o vi

eval "$(atuin init bash)"
eval "$(zoxide init bash)"
eval "$(direnv hook bash)"
eval "$(starship init bash)"

alias cd="z"
alias cdi="zi"

alias vi="nvim"
alias vim="nvim"

alias cat="bat"

alias ls="eza --icons --all --oneline --sort=type"

[[ ! ${BLE_VERSION-} ]] || ble-attach
