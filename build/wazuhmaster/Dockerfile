FROM wazuh/wazuh
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qy python-pip groff-base 
RUN pip install awscli
USER root
COPY ./s3copy.sh /s3copy.sh
RUN chmod 0755 /s3copy.sh
