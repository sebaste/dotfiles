#!/bin/csh -f

# Skip the rest if the shell is not interactive.
if ($?USER == 0 || $?prompt == 0) exit

set _CSH_DIR = ~/.csh.d
set _SHELLS_DIR = ~/.shells.d

set _UMASK = `cat $_SHELLS_DIR/umask-i`
umask $_UMASK
unset _UMASK

which setxkbmap >&/dev/null
if ( $status == 0 ) then
    set _XKBMAP = `cat $_SHELLS_DIR/xkbmap-s`
    setxkbmap $_XKBMAP
    unset _XKBMAP
endif

if ( $?tcsh ) then
    # The default location in which "history -S" and "history -L" look for a history file.
    # FIXME: the history file in use should be ~/.history.tcsh.
    set histfile = "~/.history.tcsh"

    set _HIST_SIZE = `cat $_SHELLS_DIR/history.size.session-i`
    set history = $_HIST_SIZE
    unset _HIST_SIZE

    # If set, the shell does "history -S" before exiting. If the first word is set to a number, at most that many
    # lines are saved.
    # "merge": The history list is merged with the existing history file instead of replacing it (if there is one)
    # and sorted by time stamp and the most recent events are retained.
    # "merge lock": The history file update will be serialized with other shell sessions that would possibly
    # like to merge history at exactly the same time.
    set savehist = merge lock
endif

source $_CSH_DIR/options

source $_SHELLS_DIR/clean
source $_SHELLS_DIR/local.clean

set _SCRIPT = $_CSH_DIR/export_from_prio_list.csh
set _ARG_FILE = "${_SHELLS_DIR}/env.browser-l"
set _ARG_VAR = "BROWSER"
source $_SCRIPT
set _ARG_FILE = "${_SHELLS_DIR}/env.pager-l"
set _ARG_VAR = "PAGER"
source $_SCRIPT
set _ARG_FILE = "${_SHELLS_DIR}/env.editor-l"
set _ARG_VAR = "EDITOR"
source $_SCRIPT
setenv VISUAL "${EDITOR}"

unset _ARG_VAR

set _SCRIPT = $_CSH_DIR/read_aliases_file.csh
set _ARG_FILE = "${_SHELLS_DIR}/aliases"
source $_SCRIPT
which pacman >&/dev/null
if ( $status == 0 ) then
    set _ARG_FILE = "${_SHELLS_DIR}/aliases.archlinux"
    source $_SCRIPT
endif
which apt-get >&/dev/null
if ( $status == 0 ) then
    set _ARG_FILE = "${_SHELLS_DIR}/aliases.debian"
    source $_SCRIPT
endif
if ( -d /proc/acpi/battery/BAT* || \
     -d /sys/module/battery ) then # If running Debian.
    set _ARG_FILE = "${_SHELLS_DIR}/aliases.laptop"
    source $_SCRIPT
endif
source $_CSH_DIR/aliases
set _ARG_FILE = "${_SHELLS_DIR}/local.aliases"
source $_SCRIPT

set _SCRIPT = "${_CSH_DIR}/read_env_file.csh"
set _ARG_FILE = "${_SHELLS_DIR}/env.dirs.home"
source $_SCRIPT
set _ARG_FILE = "${_SHELLS_DIR}/env.dirs"
source $_SCRIPT
set _ARG_FILE = "${_SHELLS_DIR}/env.grep"
source $_SCRIPT
set _ARG_FILE = "${_SHELLS_DIR}/env.editor"
source $_SCRIPT
set _ARG_FILE = "${_SHELLS_DIR}/env.path"
set _ARG_READ_PATH
source $_SCRIPT
unset _ARG_READ_PATH
set _ARG_FILE = "${_SHELLS_DIR}/local.env"
source $_SCRIPT

unset _SCRIPT
unset _ARG_FILE

set _TERM_NM_COLORS = 0
which tput >&/dev/null
if ( $status == 0 ) then
    set _TERM_NM_COLORS = `tput colors`
    if ( "$TERM" == "xterm" && $_TERM_NM_COLORS != 256 ) then
        set _TERM_BKP = "${TERM}"
        set _TERM_NM_COLORS_BKP = "${_TERM_NM_COLORS}"
        # If "xterm-256color" was not read from .Xresources, then try to enforce it.
        setenv TERM "xterm-256color"
        set _TERM_NM_COLORS = `tput colors`
        if ( $_TERM_NM_COLORS != 256 ) then
            setenv TERM "${_TERM_BKP}"
            set _TERM_NM_COLORS = "${_TERM_NM_COLORS_BKP}"
        endif
    endif
endif

which colordiff >&/dev/null
if ( $status == 0 && $_TERM_NM_COLORS >= 8 ) then
    alias diff colordiff
endif

set _CHARMAP
which locale >&/dev/null
if ( $status == 0 ) then
    set _CHARMAP = `locale charmap`
endif

source $_CSH_DIR/prompt

if ( $PAGER == "less" ) then
    # Less filter for viewing non-text files.
    which lesspipe >&/dev/null
    if ( $status == 0 ) then
        set _LESSPIPE = `which lesspipe`
        setenv LESSOPEN "| ${_LESSPIPE} %s" 
        unset _LESSPIPE
    endif
    if ( $_CHARMAP == "UTF-8" ) then
        setenv LESSCHARSET "utf-8"
    endif
    if ( $_TERM_NM_COLORS == 256 ) then
        set _ARG_FILE = "${_SHELLS_DIR}/env.less.termcaps.256"
        source "${_CSH_DIR}/read_env_file.csh"
        unset _ARG_FILE
    endif
endif

if ( $_TERM_NM_COLORS == 256 && -r ~/.dir_colors ) then
    eval "dircolors -b ~/.dir_colors >&/dev/null"
endif

unset _CSH_DIR
unset _SHELLS_DIR
unset _TERM_NM_COLORS
unset _CHARMAP
