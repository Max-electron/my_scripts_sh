#!/usr/bin/expect -f
set timeout 1
spawn /opt/emc/boostfs/bin/boostfs lockbox set -d aaaa -s aaaa -u aaaa
expect "Enter storage unit user password:\r"
send -- "aaaa\r"
expect "Enter storage unit user password again to confirm:\r"
send -- "aaaa\r"
expect eof

