#!/bin/sh

##########################################################################
# JBoss Application Server startup script
# 1.- Configure admin passowrd
# 2.- Execute custom scripts in /jboss/scripts/jboss-appserver/init
# 3.- Start JBoss Application Server 
##########################################################################

# Check if any jboss appserver (wildfly, eap) admin password is set in container runtime configuration.
if [[ -z "$JBOSS_ADMIN_PASSWORD" ]] ; then
    echo "Not custom JBoss Application Server admin user password set. Using default password for admin user."
    export JBOSS_ADMIN_PASSWORD="admin123!"
fi

# Configure the jboss appserver (wildfly, eap) admin password
echo "Using '$JBOSS_ADMIN_PASSWORD' as JBoss Application Server admin password"
/opt/jboss-appserver/bin/add-user.sh admin $JBOSS_ADMIN_PASSWORD --silent

# Special user for JMX remote administration (domain mode support)
/opt/jboss-appserver/bin/add-user.sh adminjmx adminjmx123! --silent

# Obtain the container IP address
DOCKER_IP=$(/bin/sh /jboss/scripts/docker-ip.sh)

# Fix for JBOSS_ARGUMENTS env.
if [ $JBOSS_ARGUMENTS=="" ]; then
    unset JBOSS_ARGUMENTS
fi

# Check if the bind address have been set when running the container. If not, assign it the current container's IP address.
if [[ -z "$JJBOSS_BIND_ADDRESS" ]] ; then
    echo "Not custom JBoss Application Server bind address set. Using the current container's IP address '$DOCKER_IP'."
    export JBOSS_BIND_ADDRESS=$DOCKER_IP
fi

# Starts JBoss Application Server using $RUN_ARGUMENTS, specified when running the container, if any.
/jboss/scripts/jboss-appserver/start-jboss.sh $DOCKER_IP

exit 0