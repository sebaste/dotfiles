#!/bin/csh -f

set _FILE = "$_ARG_FILE"

if ( -f "${_FILE}" ) then
    # Store a backup of $argv, in case the shell config was called by another script setting argv.
    set _ARGV_BKP = ( $argv )
    foreach _LINE ( "`grep -v '^#' ${_FILE}`" )
        set argv = ( $_LINE )
        if ( $#argv < 2 ) then
            continue
        endif
        set _FIRST_ARG = "$1"
        shift argv
        alias "$_FIRST_ARG" "$argv"
    end
    unset _LINE
    unset _FIRST_ARG
    # Set $argv to its previous value.
    set argv = ( $_ARGV_BKP )
    unset _ARGV_BKP
endif

unset _FILE
