ARG EOS_VERSION="4.6.5"
FROM owncloud/eos-base:${EOS_VERSION}

RUN rpm --rebuilddb && yum -y install \
    jq \
    cryptsetup \
    e2fsprogs \
    xfsprogs \
    smartmontools && \
    yum clean all && \
    rm -rf /var/cache/yum

COPY etc/xrd.cf.fst /etc/xrd.cf.fst 
COPY setup /setup
COPY entrypoint /entrypoint
