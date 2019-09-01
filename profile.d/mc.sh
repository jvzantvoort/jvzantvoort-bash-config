# if the wrapper does not exist, do not continue
[[ -f "~/.bash/mc/mc-wrapper.sh" ]] || return 0

# Don't define aliases in plain Bourne shell
[ -n "${BASH_VERSION}${KSH_VERSION}${ZSH_VERSION}" ] || return 0
alias mc='. /usr/libexec/mc/mc-wrapper.sh'

# re-alias mc
unalias mc
alias mc='. ~/.bash/mc/mc-wrapper.sh'
