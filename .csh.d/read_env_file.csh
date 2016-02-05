#!/bin/csh -f

set _FILE = "$_ARG_FILE"

if ( -r "${_FILE}" ) then
    # Store a backup of $argv, in case the shell config was called by another script setting argv.
    set _ARGV_BKP = ( $argv )
    set nonomatch
    foreach _LINE ( "`grep -v '^#' ${_FILE}`" )
        set argv = ( $_LINE )
        if ( $#argv < 2 ) then
            continue
        endif
        set _FIRST_ARG = "$1"
        shift argv
        # Semicolons need to be escaped before eval.
        set _REM_ARGS = `echo $argv | sed "s/;/\\;/g"`
        if $?_ARG_READ_PATH then
            set _REM_ARGS = `echo $argv | sed "s/:/\\:/g"`
        endif
        # Extend variables.
        set _REM_ARGS = `eval "echo ${_REM_ARGS}"`
        setenv ${_FIRST_ARG} "${_REM_ARGS}"
    end
    unset _LINE
    unset _FIRST_ARG
    unset _REM_ARGS
    # Set $argv to its previous value.
    set argv = ( $_ARGV_BKP )
    unset _ARGV_BKP
endif

unset _FILE
