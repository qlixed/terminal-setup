
# Shell Params to setup
#======================
# Write the path, and bum!, cd path is done
shopt -s autocd
# Simple bad dir spelling is corrected
shopt -s cdspell
# Multiline cmd is saved on history
shopt -s cmdhist
# Variable path expansion, like ~<tab> goes to /home/username/
shopt -s direxpand
# Simple bad dir spelling is corrected during autocomplete.
shopt -s dirspell
# Append History, no Overwrite
shopt -s histappend
# Allow history edition on fail
shopt -s histreedit
shopt -s histverify

# Enviroment Thingys:
#======================
#Never clear screen when get out
export PAGER='less -X'
#Increase history as we append all ttys now.
export HISTSIZE=10000


# Command Aliases and shortcuts
#======================
#Never clear screen when get out
#Exit if all the content is less than a page.
alias less='less -X -F'

#Some ls shortcuts:
alias ls='ls -F --color=auto'
alias l='ls -lh'
alias ll='ls -lha'
alias llz='ls -Zhal'

#Python help as a man:
alias pyman="python -c \"import sys;help('{0}'.format(sys.argv[2]))\" -- $@"

#Lazy vi/vim replacemente for some weird systems
alias vi="vim"

#tmux shortcuts:
alias tmuxkillall="tmux ls | cut -d : -f 1 | xargs -I {} tmux kill-session -t {}"
alias tka=tmuxkillall

#Few handy alias for virtualenvwrapper
venv=$(whereis -b virtualenvwrapper.sh | cut -d" " -f2)
if [[ ! -z venv ]];then
    WORKON_HOME='~/src/'
    source $venv
    
    alias mkvenv=mkvirtualenv
    alias lsvenv=lssitepackages
fi
unset vnev

