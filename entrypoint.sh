#!/bin/sh

set -eo pipefail

spec="$INPUT_SPEC"
version="$INPUT_VERSION"
release="$INPUT_RELEASE"

target=".rpmbuild"
no_clean=""

name="$(grep ^Name ${spec} | cut -f 2 -d : | xargs echo)"
dist="$(rpm --eval '%{?dist}')"
srpm="${name}-${version}-${release}${dist}.src.rpm"

[ -d "${target}" ] && rm -fr ${target}
mkdir -p ${target}/{SOURCES,BUILD,RPMS,SRPMS,BUILDROOT,SPECS}

git archive --output=${target}/SOURCES/${name}-${version}.tar.gz \
  --prefix=${name}-${version}/ HEAD

rpmbuild --define "_topdir ${PWD}/${target}" \
  --define "version ${version}" --define "release ${release}" -bs ${spec}

yum-builddep -y ${target}/SRPMS/${srpm}

rpmbuild --define "_topdir ${PWD}/${target}" \
  --define "version ${version}" --define "release ${release}" -bb ${spec}

echo "rpms_path=${target}/RPMS" >> $GITHUB_OUTPUT
