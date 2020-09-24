#!/bin/bash
# Shell script to generate increasing load in steps and automatically scale down after error.
# vary load by changing values for initialThreads, step, loopsPerThread
#


# 0 is step up, non zero is step down
#
stepDirection=0
initialThreads=5
maxThreads=400
currentThreads=0
stepSize=5
rampupTime=30
loopsPerThread=5
requestsPerLoop=6


while :
do
        rm -rf /var/log/jmeter.log
        if [ $stepDirection == 0 ]
        then
            # Step Up
            currentThreads=$((currentThreads+stepSize))
        else
            # Step Down
            currentThreads=$((currentThreads-stepSize))
        fi
        if [ $currentThreads -le $initialThreads ]
        then
            currentThreads=$initialThreads
            stepDirection=0
        fi
        if [ $currentThreads -ge $maxThreads ]
        then
            currentThreads=$maxThreads
            stepDirection=1
        fi
        touch /var/log/test_plan.jtl
        cp /data/mysql-connector-java-8.0.18/mysql-connector-java-8.0.18.jar /opt/apache-jmeter-5.1.1/lib/.; cp /data/jolokia.jar /opt/apache-jmeter-5.1.1/lib/.; cd $JMETER_HOME/bin && /usr/bin/java -server $JAVA_ARGS $JVM_ARGS $JAVA_AGENT -jar $JMETER_HOME/bin/ApacheJMeter.jar -n -t /scripts/test_plan.jmx -l /var/log/test_plan.jtl -LINFO -j /var/log/jmeter.log  -Jthreads=${currentThreads} -Jrampuptime=${rampupTime} -Jloopsperthread=${loopsPerThread} -JPETCLINC_HOST=${PETCLINC_HOST} -JPETCLINIC_PORT=${PETCLINIC_PORT} -JMYSQL_SERVER=${DATABASE_HOST}:3306 -JMYSQL_USER=${DATABASE_USERNAME} -JMYSQL_PASSWORD=${DATABASE_PASSWORD};
        # Decide number of response lines to check for error
        #
        responseLines=$((currentThreads*loopsPerThread*requestsPerLoop))

        #1594296081119,8,addOwner,302,,Thread Group 1-13,,true,,232,301,1,1,http://172.31.64.251/owners/new,8,0,0
        # Any error in response, then start step down
        #
        errors=$(tail -n $responseLines /var/log/test_plan.jtl |  awk -F "," '{print $4}' | grep -c '5')
        # If there are more than 20% error, then start step down
        #
        if [ $errors -ge $((responseLines / 5)) ]
        then
            stepDirection=1
        fi
        sleep 300
        # /usr/sbin/logrotate -f /etc/logrotate.d/jmeter_logrotate
done
