#!/usr/bin/expect -f
spawn themepacksupport

expect "(H)omescreen refresh"
send "h"

expect "Refresh the homescreen"
send "y"

expect "done"
send "q"
