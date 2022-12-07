#!/bin/sh

set -eo pipefail

version="$INPUT_VERSION"
spec="$INPUT_SPEC"
release="1"

target="${PWD}/.rpmbuild"
no_clean=""

dist="$(rpm --eval '%{?dist}')"
srpm="collectd-${version}-${release}${dist}.src.rpm"

[ -d "${target}" ] && rm -fr ${target}
mkdir -p ${target}/{SOURCES,BUILD,RPMS,SRPMS,BUILDROOT,SPECS}

git archive --output=${target}/SOURCES/collectd-${version}.tar.gz \
  --prefix=collectd-${version}/ HEAD

rpmbuild --define "_topdir ${target}" \
  --define "version ${version}" --define "release ${release}" -bs ${spec}

dnf config-manager --set-enabled devel
dnf builddep -y ${target}/SRPMS/${srpm}

rpmbuild --define "_topdir ${target}" \
  --define "version ${version}" --define "release ${release}" -bb ${spec}

find ${target}
