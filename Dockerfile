
FROM rockylinux:9

RUN dnf config-manager --set-enabled crb && \
    dnf config-manager --set-enabled devel && \
    dnf install -y epel-release git rpm-build dnf-plugins-core

COPY entrypoint.sh /
ENTRYPOINT ["sh", "/entrypoint.sh"]
