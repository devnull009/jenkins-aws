FROM jenkins/jenkins:lts
COPY basic-security.groovy /usr/share/jenkins/ref/init.groovy.d/basic-security.groovy
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
