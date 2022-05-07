#!/bin/bash
if [ -d "${HOME}/.bashrc.d" ]; then
    cp bashrc_ps1.sh "${HOME}/.bashrc.d/" -rfp
else
    ansible-playbook install_bashrc_prompt_playbook.yml -l localhost -vvv
fi
