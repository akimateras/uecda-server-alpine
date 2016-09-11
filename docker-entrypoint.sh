#!/bin/sh
set -e

# use console mode if $DISPLAY is not given
if [ ! $DISPLAY ]; then
    sed -ri 's/^(WINDOW_TYPE\s+new_normal)/#\1/' /uecda/tndhms.cfg
    sed -ri 's/^#(WINDOW_TYPE\s+console)/\1/' /uecda/tndhms.cfg
    sed -ri 's/^(GRAPH_WINDOW\s+middle)/#\1/' /uecda/tndhms.cfg
    sed -ri 's/^#(GRAPH_WINDOW\s+none)/\1/' /uecda/tndhms.cfg
fi

# apply given parameters for config
variables=`grep -aE '^[^#]' /uecda/tndhms.cfg | sed -r 's/^(\S+)\s+.+$/\1/'`
while read var
do
    val=`eval echo '$'$var`
    if [ $val ]; then
        echo $var=$val
        sed -ri 's/^('$var'\s+).+$/\1'$val'/' '/uecda/tndhms.cfg'
    fi
done << END
$variables
END
unset var
unset val

# fix command
if [ "${1:0:1}" = '-' ]; then
    set -- './tndhms' "$@"
fi

exec "$@"
