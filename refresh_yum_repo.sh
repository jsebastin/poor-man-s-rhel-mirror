#!/bin/bash
#
# Description:
# Script to refresh a YUM repository after you have added some RPMs
#
# License: MIT copyright (c) 2016 Joerg Kastning <joerg.kastning(aet)uni-bielefeld(dot)de>

# Variablen ###################################################################
HOST="http://fqdn" # FQDN of the local mirror server
BASEDIR="/var/www/html/local-rhel-7-repo/" # Dir with the repos of the mirror
REPONAME="" # Name of the repo which should be refreshed
LOG="/var/log/refresh_yum_repo.log"

# Funktionen ##################################################################
usage()
{
  cat << EOF
  usage: $0 OPTIONS
  This script refreshes the metadata of your yum repository after you have
  added some new RPMs.
  
  Before the first run the variables BASEDIR and HOST needs to be defined.
  REPONAME could be defined in the script itself or passed to the script by
  parameter.

  OPTIONS:
  -h Shows this text
  -r <repo-name> Name of the new repository. Only A..Z, a..z, 0..9 and '-' are
     allowed for the name. The name must not contain any spaces.
EOF
}

check()
{
  if [ $1 -gt 0 ]; then
    echo "Uuups, here went something wrong."
    echo "exit $1"
    exit 1
  fi
}

refresh_repo()
{
cd $BASEDIR$REPONAME
createrepo --database $BASEDIR$REPONAME 
restorecon -R -v $BASEDIR$REPONAME/*
}

# Hauptteil #######################################################
while getopts .h:r:. OPTION
do
  case $OPTION in
    h)
       usage
       exit;;
    r)
       REPONAME="${OPTARG}"
       ;;
    ?)
       usage
       exit;;
  esac
done

if [[ -z $REPONAME ]]; then
  read -p "Please enter the repository name: " REPONAME
fi

echo \# `date +%Y-%m-%d` - START REFRESH \# > $LOG
refresh_repo >> $LOG
check $? >> $LOG
echo \# `date +%Y-%m-%d` - END REFRESH \# >> $LOG
exit 0
