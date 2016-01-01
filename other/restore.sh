#!/usr/bin/expect -f
spawn iconpacksupport
expect "(A)pply icon"
send "r"
expect "This will restore your previousl"
send "y"
expect "done"
send "h"
expect "Refresh the homescreen"
send "y"
expect "done"
send "q"
