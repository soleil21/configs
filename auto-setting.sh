#!/bin/sh
cd $(dirname $0)
for conffile in setting.d/*.conf
do
  . $conffile
  if [ ! -d $TARGETCONFDIR ] ;then
    ln -s $CONFDIR $TARGETCONFDIR
    echo "$TARGETCONFDIR created"
  else
    :
    #echo "$TARGETCONFDIR alreay created"
  fi
done
