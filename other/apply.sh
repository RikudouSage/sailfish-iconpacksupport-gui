#!/usr/bin/expect -f
set name [lindex $argv 0]
spawn iconpacksupport
expect "(A)pply icon"
send "a"
expect "Please enter the icon pack name"
send "$name\r"
expect "(A)pply icon"
send "h"
expect "Refresh the homescreen"
send "y"
expect "done"
send "q"
