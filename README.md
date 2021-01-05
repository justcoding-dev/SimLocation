# SimLocation
Update simulated location in Xcode to be updated with simple movements

In case you want to quickly test some location based features of your shiny new app without creating GPX waypoint lists yourself.

Also, if you walk around with your shiny iPhone and pretend to throw imaginary balls at imaginary creatures, feel free to imagine the walking part as well.

# Usage

Create a new Xcode project for iOS and run it on your device. 

In the _Debug_ menu, under _Simulate Location_, add a reference to the _SimLocation.gpx_ file. Then select the SimLocation entry for location simulation.

On the iOS device, switch to Maps to view the simulated location.

Run the simLocation.sh script.

Use the cursor keys to modify the current location.

Use the number keys to set the step width (0 is smallest, 9 ist largest)

Use the letter keys q...t...o to modify the movement angle by up to -/+45 degrees. For example, when you press the *UP* key, you normally move north. When pressing the *Q* key first, you will move nortwest. When you press the *U* key, UP moves 22.5 degrees nortnortheast. Press *T* to reset the angle to 0 degrees.

Press *K* or *L* to manually enter longitude and latitude values. The values *MUST* have 5 decimal digits (after the decimal point) - there is no real checking of that, so if you have a wrong number of decimal digits, you will end up somewhere else on the map.
