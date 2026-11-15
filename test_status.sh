
#!/usr/bin/env bash

# Test the disk space status logic

check_disk_status() {
    local usage=$1

    if [ "$usage" -ge 80 ]; then
        echo "WARNING"
    else
        echo "OK"
    fi
}

test_status() {
    local usage=$1
    local expected=$2
    local actual

    actual=$(check_disk_status "$usage")

    if [ "$actual" = "$expected" ]; then
        echo "PASS: ${usage}% -> $actual"
    else
        echo "FAIL: ${usage}% -> $actual (expected $expected)"
        return 1
    fi
}

test_status 50 OK
test_status 80 WARNING
test_status 90 WARNING
