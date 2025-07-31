#!/usr/bin/env elvish

if (or (not (has-external 'systemctl')) (not (has-external 'ssh-agent'))) {
    echo 'ssh-agent.elv: Nothing to do' >&2
    exit
}

e:systemctl --user enable ssh-agent.service
