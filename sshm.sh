#!/bin/bash

DEBUG=${DEBUG_SCRIPT:-0}
DEBUG=1
if [ $DEBUG -eq 1 ];then
    set -x
fi

# Control Path name:
CONTROL_PATH=ssh-mastersockets.d/
# Default control path under .ssh:
CP_LOC=$HOME/.ssh/
CLEANUP_CHECK=1

# But, if the system has tmpfs for run/user
#  we prefer to use that, so we don't need to
#  do any socket cleanup.
# Also the /run/user is more "secure" approach.
#if [ ! -d /run/user/$(id -u)/];then
#    CP_LOC=/run/user/$(id -u)/
#    CLEANUP_CHECK=0
#fi

SOCKET_FMT=%r@%h:%p
FCP=$CP_LOC$CONTROL_PATH$SOCKET_FMT
# If we don't receive data between 20 secs, send a ServerAlive msg
#   then if we send 3 and have no response, disconnect
# So if the server can't respond for 3*20s=60s the
#   connection goes down
BF="-o ServerAliveCountMax=3 -o ServerAliveInterval=20"
MF=""

if [ ! -d $CP_LOC$CONTROL_PATH ];then
    echo "ERROR: $CP_LOC$CONTROL_PATH don't exist"
    echo "\tIf this is your first time running this next step will remediate it."
    echo "- Creating $CP_LOC$CONTROL_PATH"
    mkdir -p $CP_LOC$CONTROL_PATH
    chmod 700 $CP_LOC$CONTROL_PATH
    CLEANUP_CHECK=0
fi

# Check for cleanup:
if [ $CLEANUP_CHECK -eq 1 ];then
    # VARNAME = cmd <(cmds) <(othercmds) | anothercmd
    # You might read like:
    #  stdout(cmds)+stdout(othercmds) | stdin(cmd)
    #  stdout(cmd) | stdin(anothercmd)
    #  VARNAME = stdout(anothercmd) 
    CLEANUP_LIST=$(sort <(ps -eo args | sed -n -e 's|.*ssh:\ \(.*\)\ \[mux\]|\1|p') <(ls -1 -d $CP_LOC$CONTROL_PATH*) | uniq -c | sed -n -e 's|\ *1\ \(.*\)$|\1|p')
    for f in $CLEANUP_LIST;do
        echo $f
        rm $f
    done
fi

ssh -O check -S $FCP $*

# if check fails, no master running for this connection add flags:
if [ $? -eq 255 ];then
    ssh -O exit -S $FCP $*
    MF="-M -o ControlMaster=auto -o ControlPersist=600"
fi

ssh $BF $MF -S $FCP $*

