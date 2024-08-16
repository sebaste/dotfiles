#!/bin/bash

_TERM_NM_COLORS=0
if `hash tput 2>/dev/null`; then
    _TERM_NM_COLORS=`tput colors`
fi
_PRINT_STEP_PRE="\n"
_PRINT_STEP_POST="\n"
_PRINT_STEP_COLOR=''
_PRINT_STEP_PADDING_R=''
_COLOR_RESET=''
if [[ $_TERM_NM_COLORS -eq 256 ]]; then
    _PRINT_STEP_COLOR='\e[38;5;87m'
    _PRINT_STEP_PADDING_L='\e[48;5;233m \e[48;5;234m \e[48;5;235m \e[48;5;236m'
    _PRINT_STEP_PADDING_R='\e[48;5;235m \e[48;5;234m \e[48;5;233m '
    _COLOR_RESET='\e[0m'
else
    _PRINT_STEP_PADDING_L='### '
fi
unset _TERM_NM_COLORS
function _print_step() {
    local MESSAGE=$1
    printf "${_PRINT_STEP_PRE}${_PRINT_STEP_COLOR}${_PRINT_STEP_PADDING_L}${MESSAGE}${_PRINT_STEP_PADDING_R}${_COLOR_RESET}${_PRINT_STEP_POST}"
}

function _check_config_var_E() {
    local CONFIG_VAR=$1
    if [[ -z $(eval "echo \$$CONFIG_VAR") ]]; then
        >&2 echo "Error: ${CONFIG_VAR} value not defined in configure file"
        exit 1
    fi
}

. ./.bash.d/helpers
function _mkdirp_from_env_file {
    local _FILENAME=$1
    if [ -f $_FILENAME ]; then
        local _LINE
        local _TOKENS
        local _DIR
        while read _LINE; do
            _line_is_valid "$_LINE"
            if [ "$?" != "0" ]; then
                continue
            fi
            _TOKENS=($_LINE)
            if [[ ${#_TOKENS[@]} -ge 2 ]]; then
                # Extend variables.
                _DIR=$(eval "echo \"${_TOKENS[@]:1}\"")
                # Replace '~' with $HOME.
                _DIR="${_DIR/#\~/$HOME}"
                # Values need to be exported, in order to keep any set variables for coming iterations.
                export "${_TOKENS[0]}"=`echo -e $_DIR`

                if [ ! -d "${_DIR}" ]; then
                    echo "Creating directory $_DIR"
                    mkdir -p "$_DIR"
                fi
            fi
        done < $_FILENAME
    else
        >&2 echo "Error: file $_FILENAME does not exist - cannot create directories"
    fi
}

function _clean_helpers {
    unset _PRINT_STEP_PRE
    unset _PRINT_STEP_POST
    unset _PRINT_STEP_COLOR
    unset _PRINT_STEP_PADDING_L
    unset _PRINT_STEP_PADDING_R
    unset _COLOR_RESET

    unset -f _print_step
    unset -f _check_config_var_E
    unset -f _mkdirp_from_env_file
}
