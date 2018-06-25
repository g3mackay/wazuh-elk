FROM wazuh/wazuh-kibana
USER root
ADD https://github.com/silinternational/awsops/raw/0.0.1/dist/linux/amd64/awsops /awsops
COPY ./fixconfig.sh /fixconfig.sh
RUN chmod 0755 /fixconfig.sh /awsops
