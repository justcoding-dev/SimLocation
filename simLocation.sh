#!/bin/bash

# Add the file SimLocation (found in the same directory as this script) to your XCode project
# Make sure only the Xcode with the location simulator is running.
#
# Replace the name of the Xcode project and the start coordinates below. Write the 
# coordinates without decimal dot and all 5 decimal places 
#
# Use arrow keys to de-/increase lat and lon values.


# exTODO: show new location in maps as well - nope, no dictionary

# These are the default start coordinates if no previous file could be read
initLon=677848
initLat=5122315

if [ -f "SimLocation.gpx" ]
then
	# Try to read the previous file and extract the last coordinates
	read -r lat lon <<< $(sed '/lat=/!d' SimLocation.gpx| awk -F "\"" '{print $2 " " $4}' | sed 's/\.//g' | tail -1)
	echo Read lon $lon lat $lat
else
	lat=$initLat
	lon=$initLon
fi

# Initial step width. Can be changed with number keys 0-9
step=50

# Define set of variables for new coordinates. Actually these can be removed/replaced with lon/lat
# if only the new coordinates should be stored in file (as opposed to the last waypoint and the new one)
latNew=0
lonNew=0

update() {

	echo "Moving from $lon, $lat$"
	echo "Moving to $lonNew, $latNew"

	# The additional sloN/slaN variables are to simulate movement at 
	# the target position. Looks horrible though, best to just
	# set the new target coordinates once

	# slo1=$(sed 's/\(.*\)\(.\{5\}\)/\1.\2/g' <<< "$lon")
	# sla1=$(sed 's/\(.*\)\(.\{5\}\)/\1.\2/g' <<< "$lat")

	slo2=$(sed 's/\(.*\)\(.\{5\}\)/\1.\2/g' <<< "$lonNew")
	sla2=$(sed 's/\(.*\)\(.\{5\}\)/\1.\2/g' <<< "$latNew")

	# slo3=$(sed 's/\(.*\)\(.\{5\}\)/\1.\2/g' <<< "$((lonNew + 1))")
	# sla3=$(sed 's/\(.*\)\(.\{5\}\)/\1.\2/g' <<< "$latNew")

	# slo4=$(sed 's/\(.*\)\(.\{5\}\)/\1.\2/g' <<< "$lonNew")
	# sla4=$(sed 's/\(.*\)\(.\{5\}\)/\1.\2/g' <<< "$((latNew - 1))")

	# slo5=$(sed 's/\(.*\)\(.\{5\}\)/\1.\2/g' <<< "$((lonNew - 1))")
	# sla5=$(sed 's/\(.*\)\(.\{5\}\)/\1.\2/g' <<< "$((latNew + 1))")


	/bin/cat <<EOF >SimLocation.gpx
<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<gpx>
  <wpt lat="$sla2" lon="$slo2">
    <name>WP_End</name>
  </wpt>
</gpx>
EOF

#  <wpt lat="$sla1" lon="$slo1">
#    <name>WP_Begin</name>
#  </wpt>
#  <wpt lat="$sla2" lon="$slo2">
#    <name>WP_End</name>
#  </wpt>
#  <wpt lat="$sla3" lon="$slo3">
#    <name>WP_End</name>
#  </wpt>
#  <wpt lat="$sla4" lon="$slo4">
#    <name>WP_End</name>
#  </wpt>
#  <wpt lat="$sla5" lon="$slo5">
#    <name>WP_End</name>
#  </wpt>

	# You may have to change these menu entries if your Xcode menu
	# entries are named differently (or in another language)
	osascript <<'END'
tell application "System Events"
	tell application process "Xcode"
		tell menu bar 1
			tell menu bar item "Debug"
				tell menu "Debug"
					tell menu item "Simulate Location"
						tell menu "Simulate Location"
							click menu item "SimLocation"
						end tell
					end tell
				end tell
			end tell
		end tell
	end tell
end tell
END

	lon=$lonNew
	lat=$latNew

}



while true
do
    read -r -sn1 t
    case $t in
        A) latNew=$((lat + step)) ; lonNew=$((lon + step * off / 4)) ; echo right ; update ;;
        B) latNew=$((lat - step)) ; lonNew=$((lon - step * off / 4)) ; echo left ; update ;;
        C) lonNew=$((lon + step)) ; latNew=$((lat - step * off / 4)) ; echo up ; update ;;
        D) lonNew=$((lon - step)) ; latNew=$((lat + step * off / 4)); echo down ; update ;;
		0) step=1 ; echo Steps: $step ;;
		1) step=10 ; echo Steps: $step ;;
		2) step=20 ; echo Steps: $step ;;
		3) step=50 ; echo Steps: $step ;; 
		4) step=100 ; echo Steps: $step ;;
		5) step=500 ; echo Steps: $step ;;
		6) step=1000 ; echo Steps: $step ;;
		7) step=5000 ; echo Steps: $step ;;
		8) step=10000 ; echo Steps: $step ;;
		9) step=100000 ; echo Steps: $step ;;
		q) off=-4 ; echo Offset: $off ;;
		w) off=-3 ; echo Offset: $off ;;
		e) off=-2 ; echo Offset: $off ;;
		r) off=-1 ; echo Offset: $off ;;
		t) off=0 ; echo Offset: $off ;;
		y) off=1 ; echo Offset: $off ;;
		u) off=2 ; echo Offset: $off ;;
		i) off=3 ; echo Offset: $off ;;
		o) off=4 ; echo Offset: $off ;;

    esac

done
