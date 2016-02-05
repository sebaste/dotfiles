#!/bin/csh -f

set _FILE = "$_ARG_FILE"
set _VAR = "$_ARG_VAR"

if ( -r "${_FILE}" ) then
    set nonomatch
    foreach _LINE ( "`grep -v '^#' ${_FILE}`" )
        which "${_LINE}" >&/dev/null
        if ( $status == 0 ) then
            setenv ${_VAR} "${_LINE}"
            break
        endif
    end
    unset _LINE
endif

unset _FILE
unset _VAR
