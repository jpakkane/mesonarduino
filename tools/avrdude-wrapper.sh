#!/bin/sh

# Get the port from the -P argument to avrdude(-wrapper)
ARDUINO_PORT=$(echo "$@" |grep -Po '(?<=-P) *[A-Za-z0-9/]*' | awk '{ print $1 }')
{
    # Wait for device to disappear first. This marks the reboot of the device.
    while [ -c "${ARDUINO_PORT}" ] ; do : ; done
    # Now we wait for the device to reappear (and udev makes it writable) before invoking avrdude
    while [ ! -c "${ARDUINO_PORT}" ] || [ ! -w "${ARDUINO_PORT}" ]; do : ; done

    avrdude "$@"
} &

stty -F ${ARDUINO_PORT} 1200
wait $!
