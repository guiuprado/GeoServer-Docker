#!/bin/bash

gs_ver="2.16.0"
resource="resources/plugins"
plugin_ext="zip"
plugin_sufix="plugin"
plugin_prefix="geoserver"
plugin_url="http://downloads.sourceforge.net/project/geoserver/GeoServer/${gs_ver}/extensions"
plugin_name=("arcsde" "charts" "control-flow" "css" "dxf" "excel" "gdal" "h2" "imagemap" "importer" "libjpeg-turbo" "monitor" "printing" "pyramid" "sqlserver" "vectortiles" "wps" "ysld" "sldservice" "geofence" "geofence-server")
plugin_len=${#plugin_name[@]}

# Create plugins folder if does not exist
if [ ! -d ./$resource ]
then
    mkdir -p ./$resource
fi

# Add in selected plugins.  Comment out or modify as required
for (( i=0; i<$plugin_len; i++ ))
do
    plugin_webfile="${plugin_prefix}-${gs_ver}-${plugin_name[$i]}-${plugin_sufix}.${plugin_ext}"
    plugin_file="${resource}/${plugin_prefix}-${plugin_name[$i]}-${plugin_sufix}.${plugin_ext}"

    if [ ! -f  ${plugin_file} ]; then
        wget -c "${plugin_url}/${plugin_webfile}" -O "${plugin_file}";
    fi
done

docker build --build-arg "TOMCAT_EXTRAS=false GDAL_NATIVE=true" -t soulcore/${plugin_prefix}:${gs_ver} .
## Note: disabling GWC may conflict with plugins in 2.9+ that have this as a dependency
#docker build --build-arg DISABLE_GWC=true --build-arg TOMCAT_EXTRAS=false -t thinkwhere/geoserver .
