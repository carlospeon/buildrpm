
FROM rockylinux:8

RUN dnf config-manager --set-enabled powertools && \
    dnf config-manager --set-enabled devel && \
    dnf install -y epel-release git rpm-build dnf-plugins-core

COPY entrypoint.sh /
ENTRYPOINT ["sh", "/entrypoint.sh"]
