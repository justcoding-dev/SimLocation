#!/bin/bash

# Add the file SimLocation (found in the same directory as this script) to your XCode project
# Make sure only the Xcode with the location simulator is running.
#
# Replace the name of the Xcode project and the start coordinates below. Write the 
# coordinates without decimal dot and all 5 decimal places 
#
# Use arrow keys to de-/increase lat and lon values (i.e. step across the map).
# Use number keys to define the step length
# Use the letter row q..t..o to adjust the stepping angle up to +/- 45 degress
# Press x to exit

# These are the default start coordinates if no previous file could be read
# Internally only integer is used for calculations, it is assumed that they always
# have 5 digits after the decimal point.
initLon=677848
initLat=5122315


# Initial step width. Can be changed with number keys 0-9
step=20

#############################################################################
# Nothing to edit below this line
#############################################################################

# Takes a string of digits and adds a dot at before the fifth column from the right
addDecimal() {
	echo $(sed 's/\(.*\)\(.\{5\}\)/\1.\2/g' <<< "$1")
}

# Try to read coordinates from previous file
if [ -f "SimLocation.gpx" ]
then
	# Try to read the previous file and extract the last coordinates
	read -r lat lon <<< $(sed '/lat=/!d' SimLocation.gpx| awk -F "\"" '{print $2 " " $4}' | sed 's/\.//g' | tail -1)
	echo "Read start position lon $(addDecimal $lon) lat $(addDecimal $lat)"
else
	lat=$initLat
	lon=$initLon
	echo "Default start position: lon $(addDecimal $lon) lat $(addDecimal $lat)"
fi

# Define set of variables for new coordinates. Actually these can be removed/replaced with lon/lat
# if only the new coordinates should be stored in file (as opposed to the last waypoint and the new one)
latNew=0
lonNew=0


update() {

	# echo "Moving from $(sed 's/\(.*\)\(.\{5\}\)/\1.\2/g' <<< "$lon"), $(sed 's/\(.*\)\(.\{5\}\)/\1.\2/g' <<< "$lat")"

	# The additional sloN/slaN variables are to simulate movement at 
	# the target position. Looks horrible though, best to just
	# set the new target coordinates once

	# slo1=$(sed 's/\(.*\)\(.\{5\}\)/\1.\2/g' <<< "$lon")
	# sla1=$(sed 's/\(.*\)\(.\{5\}\)/\1.\2/g' <<< "$lat")

	slo2=$(addDecimal $lonNew)
	sla2=$(addDecimal $latNew)
	echo "Moving to $slo2, $sla2"

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
	osascript << EOF > /dev/null
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
EOF

	lon=$lonNew
	lat=$latNew

}

# Usage: readValue type result
# type is a string that is displayed in the user query
# result is the variable that should hold the entered value 
readValue() {

	local __result=$3
	local current=$(addDecimal $2)

	echo "Enter new value for $1 ((curent: $current, 5 decimal places)"

	local user_input
	read user_input

	user_input=$(sed 's/\.//g' <<< "$user_input")
	eval $__result="'$user_input'"

}

# This is the endless loop to read a keypress and act upon it
while true
do
    read -r -sn1 t
    case $t in

    	# Step right
        A) latNew=$((lat + step)) ; lonNew=$((lon + step * off / 4)) ; update ;;

		# Step left
        B) latNew=$((lat - step)) ; lonNew=$((lon - step * off / 4)) ; update ;;

		# Step up
        C) lonNew=$((lon + step)) ; latNew=$((lat - step * off / 4)) ; update ;;

		# Step down
        D) lonNew=$((lon - step)) ; latNew=$((lat + step * off / 4)) ; update ;;

		# Adjust step width
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

		# Adjust stepping angle CCW to n/4 of 45 degrees
		q) off=-4 ; echo Offset: $off ;;
		w) off=-3 ; echo Offset: $off ;;
		e) off=-2 ; echo Offset: $off ;;
		r) off=-1 ; echo Offset: $off ;;

		# Reset stepping angle
		t) off=0 ; echo Offset: $off ;;

		# Adjust stepping angle CW to n/4 of 45 degress
		y) off=1 ; echo Offset: $off ;;
		u) off=2 ; echo Offset: $off ;;
		i) off=3 ; echo Offset: $off ;;
		o) off=4 ; echo Offset: $off ;;

		# Enter new longitude value
		k) readValue "lon" $lon lonNew ; latNew=$lat ; update ;;

		# Enter new latitude value
		l) readValue "lat" $lat latNew ; lonNew=$lon ; update ;;
	
		x) echo "Done." ; exit 0 ;;

   esac

done
