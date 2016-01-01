#!/usr/bin/expect -f

#gets first argument, which is the name of icon pack
set name [lindex $argv 0]
#loads iconpacksupport app
spawn iconpacksupport
#waits for text
expect "(A)pply icon"
#sends a, which means apply icon
send "a"
#then waits for this string
expect "Please enter the icon pack name"
#and sends the name of the icon pack
send "$name\r"
expect "(A)pply icon"
#sends h, which means restart homescreen
send "h"
expect "Refresh the homescreen"
#send y, e.g. yes and proceed with homescreen restart
send "y"
#when we see the string done, we can later send q, e.g. quit
expect "done"
send "q"
