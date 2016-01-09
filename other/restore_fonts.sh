#!/usr/bin/expect -f
spawn themepacksupport

expect "(I)con theme"
send "f"

expect "(R)estore"
send "r"

expect "This will restore your default icon pack"
send "y"

expect "done"
send "b"

expect "(I)con theme"
send "q"
