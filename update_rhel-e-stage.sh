#!/bin/bash
# Wrapper-Script to update the rhel-e-stage
# License: MIT copyright (c) 2016 Joerg Kastning <joerg.kastning(aet)uni-bielefeld(dot)de>
PROGDIR=/root/bin
$PROGDIR/rsync_repo.sh -Q rhel-7-server-rpms -Z rhel-e-stage
exit
