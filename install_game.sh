#!/bin/bash

# Check if we've already installed the Starbound.
if [ ! -f "/opt/steam/starbound" ]; then
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
	echo "Some error occurred during installation of Starbound. If you have Steam Guard configured, please set STEAM_OTP environment variable with your current OTP Token and redeploy."
	echo "e.g."
        echo "$ oc set env dc/starbound STEAM_OTP=5TD32"
fi
