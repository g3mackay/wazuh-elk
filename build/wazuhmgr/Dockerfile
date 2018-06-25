FROM wazuh/wazuh
USER root
ADD https://github.com/silinternational/awsops/raw/0.0.1/dist/linux/amd64/awsops /awsops
COPY ./fixwazconfig.sh /fixwazconfig.sh
RUN chmod 0755 /fixwazconfig.sh /awsops
