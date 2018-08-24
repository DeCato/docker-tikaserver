#!/usr/bin/env bash
cat >/etc/motd <<EOL 
  _________      .__ __                  
 /   _____/_____ |__|  | __ ____   ______
 \_____  \\____ \|  |  |/ // __ \ /  ___/
 /        \  |_> >  |    <\  ___/ \___ \ 
/_______  /   __/|__|__|_ \\___  >____  >
        \/|__|           \/    \/     \/ 

A Z U R E
A P P   S E R V I C E   O N   L I N U X

EOL
cat /etc/motd

service ssh start

# Get environment variables to show up in SSH session
eval $(printenv | awk -F= '{print "export " $1"="$2 }' >> /etc/profile)
