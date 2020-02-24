#!/usr/bin/env bash

# Downloads the agent from already running Jenkins instance
wget http://$url/jnlpJars/agent.jar

# Executes Jenkins slave with provided secret
java -jar /agent.jar -jnlpUrl http://$url/computer/$node/slave-agent.jnlp -secret $secret
