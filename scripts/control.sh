#!/bin/sh
#
#    Licensed to the Apache Software Foundation (ASF) under one or more
#    contributor license agreements.  See the NOTICE file distributed with
#    this work for additional information regarding copyright ownership.
#    The ASF licenses this file to You under the Apache License, Version 2.0
#    (the "License"); you may not use this file except in compliance with
#    the License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#
# chkconfig: 2345 20 80
# description: Apache NiFi is a dataflow system based on the principles of Flow-Based Programming.
#

# Script structure inspired from Apache Karaf and other Apache projects with similar startup approaches

export NIFI_DEFAULT_HOME=/opt/cloudera/parcels/NIFI
NIFI_HOME=${NIFI_HOME:-$CDH_NIFI_HOME}
export NIFI_HOME=${NIFI_HOME:-$NIFI_DEFAULT_HOME}

PROGNAME=`basename "$0"`

warn() {
    echo "${PROGNAME}: $*"
}

die() {
    warn "$*"
    exit 1
}

locateJava() {
	echo
    export JAVA_HOME=/usr/java/latest
    echo "Changing Java Home to: $JAVA_HOME"
	export JAVA="$JAVA_HOME/bin/java"
	echo "Changing Java to: $JAVA"
    echo
}

config() {
	echo
	echo "Moving nifi.properies file"
	echo
	cp -uf nifi.properties $NIFI_HOME/conf/
}

init() {
    # Locate the Java VM to execute
    locateJava
	config
}

run() {
    $NIFI_HOME/bin/nifi.sh $@
}

main() {
    init
    run "$@"
}


case "$1" in
    start|stop|run|status|dump)
        main "$@"
        ;;
    restart)
        init
	run "stop"
	run "start"
	;;
    *)
        echo "Usage nifi {start|stop|run|restart|status|dump}"
        ;;
esac
