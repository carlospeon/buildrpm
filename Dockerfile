
FROM rockylinux:8

RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && dnf install -y git rpm-build dnf-plugins-core

COPY entrypoint.sh /
ENTRYPOINT ["sh", "/entrypoint.sh"]
