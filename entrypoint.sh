#!/bin/sh

set -eo pipefail

spec="$INPUT_SPEC"
version="$INPUT_VERSION"
release="$INPUT_RELEASE"

target=".rpmbuild"
no_clean=""

dist="$(rpm --eval '%{?dist}')"
srpm="collectd-${version}-${release}${dist}.src.rpm"

[ -d "${target}" ] && rm -fr ${target}
mkdir -p ${target}/{SOURCES,BUILD,RPMS,SRPMS,BUILDROOT,SPECS}

git archive --output=${target}/SOURCES/collectd-${version}.tar.gz \
  --prefix=collectd-${version}/ HEAD

rpmbuild --define "_topdir ${PWD}/${target}" \
  --define "version ${version}" --define "release ${release}" -bs ${spec}

dnf config-manager --set-enabled devel
dnf builddep -y ${target}/SRPMS/${srpm}

rpmbuild --define "_topdir ${PWD}/${target}" \
  --define "version ${version}" --define "release ${release}" -bb ${spec}

echo "rpms_path=${target}/RPMS" >> $GITHUB_OUTPUT
