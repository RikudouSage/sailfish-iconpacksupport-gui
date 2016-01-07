#!/usr/bin/expect -f
spawn themepacksupport

expect "(I)con theme"
send "i"

expect "(R)estore"
send "r"

expect "This will restore your default icon pack"
send "y"

expect "done"
send "b"

expect "(H)omescreen refresh"
send "h"

expect "Refresh the homescreen"
send "y"

expect "done"
send "q"
