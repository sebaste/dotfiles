main() {

# hash is used consistently to check the existence of programs, since hash will not return true
# for aliases. type, command and which should not be used (especially not which).

# Skip the rest if the shell is not interactive.
[ -z "$PS1" ] && return

local _BASH_DIR=~/.bash.d
local _SHELLS_DIR=~/.shells.d

umask `cat $_SHELLS_DIR/umask-i`

if `hash setxkbmap 2>/dev/null`; then
  setxkbmap `cat $_SHELLS_DIR/xkbmap-s`
fi

HISTFILE=~/.history.bash
HISTSIZE=`cat $_SHELLS_DIR/history.size.session-i`
HISTFILESIZE=`cat $_SHELLS_DIR/history.size.file-i`
HISTIGNORE="history:ls"
# ignoredups: Ignore duplicates; ignorespace: Ignore commands starting with a whitespace.
HISTCONTROL="ignoredups:ignorespace"
HISTTIMEFORMAT="%F %T  "

. "${_BASH_DIR}/options"

. "${_BASH_DIR}/completions"

. $_SHELLS_DIR/clean
. $_SHELLS_DIR/local.clean

. $_BASH_DIR/helpers

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
if [[ -d /proc/acpi/BAT* ]] || \
   [ -d /sys/module/battery ] # If running debian.
then
    _read_aliases_file "${_SHELLS_DIR}/aliases.laptop"
fi
. "${_BASH_DIR}/aliases"
_read_aliases_file "${_SHELLS_DIR}/local.aliases"

unset -f _read_aliases_file

_read_env_file "${_SHELLS_DIR}/env.dirs.home"
_read_env_file "${_SHELLS_DIR}/env.dirs"
_read_env_file "${_SHELLS_DIR}/env.grep"
_read_env_file "${_SHELLS_DIR}/env.path"
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

. $_BASH_DIR/prompt

if [[ $PAGER == "less" ]]; then
    # Less filter for viewing non-text files.
    if `hash lesspipe 2>/dev/null`; then
        eval "$(SHELL=bin/sh lesspipe)"
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

# Set dir colors.
if [ $_TERM_NM_COLORS -eq 256 ] && [ -f ~/.dir_colors ]; then
    eval $(dircolors -b ~/.dir_colors)
fi

}

main
unset -f main
