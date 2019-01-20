#!/bin/bash

# Check if we've already installed the Starbound.
if [ -f "/opt/steam/starbound" ]; then
	echo "Starbound installed. Starting..."
	exit 0	
fi

# Check that username and password are both set
if [ -z "$STEAM_USERNAME" ] || [ -z "$STEAM_PASSWORD" ]; then
	echo "Error: STEAM_USERNAME and STEAM_PASSWORD environment variables must be set."
	exit 1
fi

# Setup username/password for Steam
sed -i "s/STEAM_USERNAME STEAM_PASSWORD/$STEAM_USERNAME $STEAM_PASSWORD/g" /opt/steam/install.txt

if [ ! -z "$STEAM_OTP" ]; then
	# Setup otp for Steam
	sed -i "s/STEAM_OTP/$STEAM_OTP/g" /opt/steam/install.txt	
fi

/opt/steam/steamcmd/steamcmd.sh +runscript /opt/steam/install.txt
if [ $? -ne 0 ]; then
	echo "Some error occurred during installation of Starbound. If you have Steam Guard configured, please execute the following command to enter your OTP token:"
        echo "$ oc exec <pod> otp <token>"
	echo "Timing out in 60 seconds..."
	mkfifo -m 600 /opt/steam/otp
        token=$(timeout 60 cat /opt/steam/otp)	
	if [ ! -z "$token" ]; then
		sed -i "s/STEAM_OTP/$token/g" /opt/steam/install.txt
		/opt/steam/steamcmd/steamcmd.sh +runscript /opt/steam/install.txt
	fi
fi

echo 'Starting starbound...'
cd /opt/steam/starbound/linux
./starbound_server 2>&1 &

child=$!
wait "$child"
