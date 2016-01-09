#!/usr/bin/expect -f

set name [lindex $argv 0]
spawn themepacksupport
expect "(I)con theme"
send "i"

expect "(A)pply icon theme"
send "a"

expect "Please enter the icon pack name"
send "$name\r"

expect "done"
send "b"

expect "done"
send "q"
