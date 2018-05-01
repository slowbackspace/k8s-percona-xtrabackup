FROM ubuntu:16.04

RUN apt-get update && apt-get install -y wget  \
    && wget --quiet https://repo.percona.com/apt/percona-release_0.1-5.xenial_all.deb \
    && dpkg -i percona-release_0.1-5.xenial_all.deb && apt-get update \
    &&  apt-get install -y percona-xtrabackup-24 libgcrypt20 openssl \ 
    && rm -f percona-release_0.1-5.xenial_all.deb \
    && wget http://www.quicklz.com/qpress-11-linux-x64.tar && tar -xf qpress-11-linux-x64.tar -C /usr/bin/
RUN apt-get install -y nano mysql-client && rm -rf /var/lib/apt/lists/*
COPY inc-backup.sh /inc-backup.sh
COPY entrypoint.sh /entrypoint.sh
COPY full-backup.sh /full-backup.sh
COPY backup-assist.sh /backup-assist.sh
COPY restore-assist.sh /restore-assist.sh
COPY restore.sh /restore.sh
ENTRYPOINT ["/entrypoint.sh"]