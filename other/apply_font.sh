#!/usr/bin/expect -f

set name [lindex $argv 0]
set android [lindex $argv 1]
set android_l [lindex $argv 2]
set sailfish [lindex $argv 3]
set sailfish_l [lindex $argv 4]
spawn themepacksupport
expect "(F)ont theme"
send "f"

expect "(A)pply font theme"
send "a"

expect "Please enter the font pack name"
send "$name\r"

expect "default font weight for Sailfish OS"
send "$sailfish\r"

expect "light font weight for Sailfish OS"
send "$sailfish_l\r"

expect {
    "Current font pack: $name" {
        send "b"

        expect "(F)ont theme"
        send "q"
    }
    "default font weight for Alien Dalvik" {
        send "$android\r"

        expect "light font weight for Alien Dalvik"
        send "$android_l\r"

        expect "Current font pack: $name"
        send "b"

        expect "(F)ont theme"
        send "q"
    }
}


