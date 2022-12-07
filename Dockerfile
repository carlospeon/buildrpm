
FROM rockylinux:8

RUN dnf install -y dnf-plugins-core && \
    dnf config-manager --set-enabled powertools && \
    dnf config-manager --set-enabled devel && \
    dnf install -y git make rpm-build epel-release

COPY entrypoint.sh /
ENTRYPOINT ["sh", "/entrypoint.sh"]
