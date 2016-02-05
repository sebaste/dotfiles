#!/bin/bash

. ./install.helpers.bash

. ./configure
_print_step "Checking variables in configure file"
_check_config_var_E INSTALL_DIR
_check_config_var_E GIT_NAME
_check_config_var_E GIT_EMAIL
echo "DONE"

_print_step "Running rsync to copy all dot files to ${INSTALL_DIR}"
rsync -av --progress . ${INSTALL_DIR} --exclude .git --exclude install.bash --exclude configure --exclude install.helpers.bash --exclude LICENSE.md --exclude README.md --exclude images

_print_step "Adding new fonts in ${INSTALL_DIR}/.fonts to cache"
fc-cache -fv ${INSTALL_DIR}/.fonts

_print_step "Adding name and email to ${INSTALL_DIR}/.gitconfig"
git config --file ${INSTALL_DIR}/.gitconfig user.name $GIT_NAME
_STATUS=$?
git config --file ${INSTALL_DIR}/.gitconfig user.email $GIT_EMAIL
_STATUS=`(( ${_STATUS} | ${?} )) && echo 1 || echo 0`
if [[ $_STATUS -eq 0 ]]; then
    echo "DONE"
else
    >&2 echo "Error: could not set user value 'name' and/or 'email' in ${INSTALL_DIR}/.gitconfig"
fi
unset _STATUS

_print_step "Creating directories stated in env.dirs.home (using mkdir -p)"
_mkdirp_from_env_file "$INSTALL_DIR/.shells.d/env.dirs.home"
echo "DONE"

_clean_helpers
unset -f _clean_helpers
