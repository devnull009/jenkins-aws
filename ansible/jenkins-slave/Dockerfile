FROM ubuntu:18.04
USER root
RUN apt-get update && apt-get install wget openjdk-8-jre -y
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD [ "bash", "-c", "/entrypoint.sh", "$url", "$node", "$secret" ]
