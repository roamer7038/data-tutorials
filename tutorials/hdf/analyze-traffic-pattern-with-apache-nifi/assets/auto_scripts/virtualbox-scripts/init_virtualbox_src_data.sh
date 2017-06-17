#!/bin/bash
echo "Creating Input Source Directory /tmp/nifi/input..."
echo "When prompted for password enter: hadoop"
ssh root@localhost -p 12122 'docker exec -d sandbox mkdir -p /tmp/nifi/input'
ssh root@localhost -p 12122 'docker exec -d sandbox chmod -R 777 /tmp/nifi'
echo "Downloading the Vehicle Location Data to Input Source..."
ssh root@localhost -p 12122 "docker exec -d sandbox wget -O /tmp/nifi/input/trafficLocs_data_for_simulator.zip 'https://github.com/hortonworks/data-tutorials/raw/master/tutorials/hdf/analyze-traffic-pattern-with-apache-nifi/assets/trafficLocs_data_for_simulator.zip'"
