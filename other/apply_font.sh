#!/usr/bin/expect -f

set name [lindex $argv 0]
spawn themepacksupport
expect "(F)ont theme"
send "f"

expect "(A)pply font theme"
send "a"

expect "Please enter the font pack name"
send "$name\r"

expect "done"
send "b"

expect "(F)ont theme"
send "q"
