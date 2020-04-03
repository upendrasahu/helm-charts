#!/bin/bash
apt-get update
apt install -y build-essential automake autoconf libtool libgeoip-dev wget ruby2.3-dev
mkdir /opt/GeoLite2-City
wget -P /opt/GeoLite2-City https://github.com/maplelabs/configurator-exporter-apm/raw/master/GeoLite2-City/GeoLite2-City.mmdb
/usr/local/bin/fluent-gem install fluent-plugin-geoip

