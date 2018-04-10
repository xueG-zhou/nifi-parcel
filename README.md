NiFi Parcel v2
===========

This repository provides a parcel(https://github.com/cloudera/cm_ext) to install Apache NiFi as a service usable by Cloudera Manager.

As base was used parcel provided by https://github.com/prateek/nifi-parcel

#Install Steps

0. Install Prerequisites: `cloudera/cm_ext`  
```sh
cd /tmp
git clone https://github.com/cloudera/cm_ext
cd cm_ext/validator
mvn install
```
1. Download NiFi:
Go to https://nifi.apache.org/download.html
Find link to binary you want to download (with tar.gz extension) 
In my case it is: https://www.apache.org/dyn/closer.lua?path=/nifi/1.4.0/nifi-1.4.0-bin.tar.gz
Then copy link of the mirror http://ftp.byfly.by/pub/apache.org/nifi/1.4.0/nifi-1.4.0-bin.tar.gz
```sh
cd /tmp
mkdir nifi
cd nifi
wget -O nifi-bin.tar.gz "http://ftp.byfly.by/pub/apache.org/nifi/1.4.0/nifi-1.4.0-bin.tar.gz"
```

2. Create parcel & CSD:
Depending on your OS version please set OS_VER variable acconringly:
- RHEL 6: OS_VER=el6
- RHEL 7: OS_VER=el7	
- Ubuntu: OS_VER=trusty
Full list of OS supported by parcels availible here: https://github.com/cloudera/cm_ext/wiki/Parcel-distro-suffixes
```sh
cd /tmp
git clone https://github.com/ibagomel/nifi-parcel.git
cd nifi-parcel
POINT_VERSION=5 VALIDATOR_DIR=/tmp/cm_ext OS_VER=el7 ./build-parcel.sh /tmp/nifi/nifi-bin.tar.gz
VALIDATOR_DIR=/tmp/cm_ext ./build-csd.sh
```

3. Serve Parcel using Python
```sh
cd build-parcel
python -m SimpleHTTPServer 14641
# navigate to Cloudera Manager -> Parcels -> Edit Settings
# Add fqdn:14641 to list of urls
# install the NIFI parcel
```

4. Move CSD to Cloudera Manager's CSD Repo
```sh
# transfer build-csd/NIFI-1.0.jar to CM's host
cd ../
cp build-csd/NIFI-1.0.jar /opt/cloudera/csd
sudo service cloudera-scm-server restart
# Wait a min, go to Cloudera Manager -> Add a Service -> NiFi
```
