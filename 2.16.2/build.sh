#!/bin/bash

gs_ver="2.16.2"
resource="resources/plugins"
plugin_ext="zip"
plugin_sufix="plugin"
plugin_prefix="geoserver"
plugin_url="http://downloads.sourceforge.net/project/geoserver/GeoServer/${gs_ver}/extensions"
plugin_name=("ysld" "css" "sldservice" "querylayer" "vectortiles" "dxf" "excel" "wps" "charts" "printing" "importer" "control-flow" "monitor" "gdal" "libjpeg-turbo" "pyramid" "sqlserver" )
plugin_len=${#plugin_name[@]}
# "geofence" "geofence-server" 
# "mysql" "mongodb" "h2" "imagemap" "arcsde"

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

docker build --build-arg TOMCAT_EXTRAS=false --build-arg GDAL_NATIVE=true --build-arg GS_VERSION=${gs_ver} -t soulcore/${plugin_prefix}:${gs_ver} . && docker push soulcore/${plugin_prefix}:${gs_ver}
## Note: disabling GWC may conflict with plugins in 2.9+ that have this as a dependency
#docker build --build-arg DISABLE_GWC=true --build-arg TOMCAT_EXTRAS=false -t thinkwhere/geoserver .