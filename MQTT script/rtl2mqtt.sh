#!/bin/bash

# A simple script that will receive events from a RTL433 SDR
# and publish them to a MQTT broker in JSON format.
#
# Author: Marco Verleun <marco@marcoach.nl>
# Version 2.0: Adapted for the new output format of rtl_433

# When run standalone the rtl_433 will report lines like:
#
# {"time" : "2016-05-11 11:39:37", "model" : "AlectoV1 Wind Sensor", "id" : 36, "channel" : 1, "battery" : "OK", "wind_speed" : 0.400, "wind_gust" : 0.400, "wind_direction" : 45}
# {"time" : "2016-05-11 11:39:50", "model" : "AlectoV1 Rain Sensor", "id" : 136, "channel" : 0, "battery" : "OK", "rain_total" : 984.000}
# {"time" : "2016-05-11 11:40:45", "model" : "AlectoV1 Temperature Sensor", "id" : 8, "channel" : 0, "battery" : "LOW", "temperature_C" : -30.100, "humidity" : 13}
# {"time" : "2016-05-11 11:43:14", "model" : "AlectoV1 Temperature Sensor", "id" : 8, "channel" : 0, "battery" : "LOW", "temperature_C" : -30.100, "humidity" : 13}
# Some of these devices aren't even mine.... And I don't trust them all

#
# Remove hash on next line for debugging
#set -x


MQTT_HOST="192.168.15.9"
MQTT_PORT="1883"
MQTT_CLIENT_ID="RTL_433"
MQTT_TOPIC="sensors/rtl_433"
MQTT_QOS="0"
MQTT_USER="rtl_433"
MQTT_PASS="rtl_433pw"

export TZ="Europe/Amsterdam"

# Keep PATH as limitted as possible
PATH=/usr/local/bin:/usr/bin:/bin

export LANG=C


#
# Start the listener and enter an endless loop
#
/usr/local/bin/rtl_433 -G -F json |  while read line
do
	# Raw message to MQTT
        echo "$line" | mosquitto_pub -u "$MQTT_USER" -P "$MQTT_PASS" \
		-h "$MQTT_HOST" -p "$MQTT_PORT" -q "$MQTT_QOS" -t "$MQTT_TOPIC" -i "$MQTT_CLIENT_ID" -l 
done

