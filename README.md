# SimLocation

Update simulated location in Xcode with simple movements

In case you want to quickly test some location based features of your shiny new app without creating GPX waypoint lists yourself.

Also, if you walk around with your shiny iPhone and pretend to throw imaginary balls at imaginary creatures, feel free to imagine the walking part as well.

You need a Mac and an iOS device for this. No, I cannot port this to windows and Android, although if you can strongarm your linux machine to simulate location in an Android phone, this script can probably be adapted to work.

# Usage

Create a new Xcode project for iOS and run it on your device. 

In the _Debug_ menu, under _Simulate Location_, add a reference to the _SimLocation.gpx_ file. Then select the SimLocation entry for location simulation.

On the iOS device, switch to Maps to view the simulated location.

Open a terminal, run the simLocation.sh script.

Use the cursor keys to modify the current location.

Use the number keys to set the step width (**1** is smallest, **0** is largest)

Use the letter keys **Q**...**T**...**O** to modify the movement angle by up to -/+45 degrees. For example, when you press the **UP** key, you normally move north. When pressing the **Q** key first, you will move nortwest. When you press the **U** key, UP moves 22.5 degrees nortnortheast. Press **T** to reset the angle to 0 degrees.

Press **K** or **L** to manually enter longitude and latitude values.