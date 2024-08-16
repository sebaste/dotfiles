function {

local _ZSH_DIR=~/.zsh.d
local _SHELLS_DIR=~/.shells.d

umask `cat "${_SHELLS_DIR}/umask-i"` 

if `hash setxkbmap 2>/dev/null`; then
    setxkbmap `cat "${_SHELLS_DIR}/xkbmap-s"`
fi

HISTFILE=~/.history.zsh
# The amount of entries that can be saved in the history file.
SAVEHIST=`cat "${_SHELLS_DIR}/history.size.file-i"`
# The amount of entries any given session can keep in memory.
HISTSIZE=`cat "${_SHELLS_DIR}/history.size.session-i"`

# Move the cursor in between the two chars when typing either '', "", (), [], or {}.
magic-single-quotes()   { if [[ $LBUFFER[-1] == \' ]]; then zle self-insert; zle .backward-char; else zle self-insert; fi }; bindkey \' magic-single-quotes
magic-double-quotes()   { if [[ $LBUFFER[-1] == \" ]]; then zle self-insert; zle .backward-char; else zle self-insert; fi }; bindkey \" magic-double-quotes
magic-parentheses()     { if [[ $LBUFFER[-1] == \( ]]; then zle self-insert; zle .backward-char; else zle self-insert; fi }; bindkey \) magic-parentheses
magic-square-brackets() { if [[ $LBUFFER[-1] == \[ ]]; then zle self-insert; zle .backward-char; else zle self-insert; fi }; bindkey \] magic-square-brackets
magic-curly-brackets()  { if [[ $LBUFFER[-1] == \{ ]]; then zle self-insert; zle .backward-char; else zle self-insert; fi }; bindkey \} magic-curly-brackets
magic-angle-brackets()  { if [[ $LBUFFER[-1] == \< ]]; then zle self-insert; zle .backward-char; else zle self-insert; fi }; bindkey \> magic-angle-brackets
zle -N magic-single-quotes
zle -N magic-double-quotes
zle -N magic-parentheses
zle -N magic-square-brackets
zle -N magic-curly-brackets
zle -N magic-angle-brackets

. "$_ZSH_DIR/options"

. "${_ZSH_DIR}/completions"

. "${_SHELLS_DIR}/clean"
. "${_SHELLS_DIR}/local.clean"

. "${_ZSH_DIR}/helpers"

_export_from_prio_list "BROWSER" "${_SHELLS_DIR}/env.browser-l"
_export_from_prio_list "PAGER" "${_SHELLS_DIR}/env.pager-l"
_export_from_prio_list "EDITOR" "${_SHELLS_DIR}/env.editor-l"
export VISUAL="${EDITOR}"

unset -f _export_from_prio_list

_read_aliases_file "${_SHELLS_DIR}/aliases"
if `hash pacman 2>/dev/null`; then
    _read_aliases_file "${_SHELLS_DIR}/aliases.archlinux"
fi
if `hash apt-get 2>/dev/null`; then
    _read_aliases_file "${_SHELLS_DIR}/aliases.debian"
fi
if [[ -d /proc/acpi/battery/BAT* ]] || \
   [ -d /sys/module/battery ] # If running debian.
then
    _read_aliases_file "${_SHELLS_DIR}/aliases.laptop"
fi
. "${_ZSH_DIR}/aliases"
_read_aliases_file "${_SHELLS_DIR}/local.aliases"

unset -f _read_aliases_file

_read_env_file "${_SHELLS_DIR}/env.dirs.home"
_read_env_file "${_SHELLS_DIR}/env.dirs"
_read_env_file "${_SHELLS_DIR}/env.grep"
_read_env_file "${_SHELLS_DIR}/env.editor"
_read_env_file "${_SHELLS_DIR}/env.path"
# Specify a hash entry for the $PRGM directory. This lets you type "~<hash tag>" to get to this directory.
hash -d prgm=$PRGM
_read_env_file "${_SHELLS_DIR}/local.env"

local _TERM_NM_COLORS=0
if `hash tput 2>/dev/null`; then
    _TERM_NM_COLORS=`tput colors`
fi
if [[ $TERM == "xterm" ]] && [[ $_TERM_NM_COLORS -ne 256 ]]; then
    local _TERM_BKP="${TERM}"
    local _TERM_NM_COLORS_BKP=$_TERM_NM_COLORS
    # If "xterm-256color" was not read from .Xresources, then try to enforce it.
    export TERM="xterm-256color"
    _TERM_NM_COLORS=`tput colors`
    if [[ $_TERM_NM_COLORS -ne 256 ]]; then
        export TERM="${_TERM_BKP}"
        _TERM_NM_COLORS=$_TERM_NM_COLORS_BKP
    fi
fi

if [[ $_TERM_NM_COLORS -ge 8 ]] && `hash colordiff 2>/dev/null`; then
    alias diff=colordiff
fi

local _CHARMAP="none"
if `hash locale 2>/dev/null`; then
    _CHARMAP=`locale charmap`
fi

. "${_ZSH_DIR}/prompt"

if [[ $PAGER == "less" ]]; then
    # Less filter for viewing non-text files.
    if `hash lesspipe`; then
        eval "$(SHELL=/bin/sh lesspipe)"
    fi
    if [[ $_CHARMAP == "UTF-8" ]]; then
        export LESSCHARSET="utf-8"
    fi
    if [[ $_TERM_NM_COLORS -eq 256 ]]; then
        _read_env_file "${_SHELLS_DIR}/env.less.termcap.256" "ANSI-C"
    fi
fi

unset -f _line_is_valid
unset -f _read_env_file

if [ $_TERM_NM_COLORS -eq 256 ] && [ -f ~/.dir_colors ]; then
    eval $(dircolors -b ~/.dir_colors)
fi

}
