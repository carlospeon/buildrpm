
FROM centos:7

RUN yum install -y yum-utils git make rpm-build epel-release

COPY entrypoint.sh /
ENTRYPOINT ["sh", "/entrypoint.sh"]
