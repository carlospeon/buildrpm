#!/bin/sh

set -eo pipefail

spec="$INPUT_SPEC"
version="$INPUT_VERSION"
clean="$INPUT_CLEAN"

if [ -z "$spec" -o  -z "$version" ]; then
  echo "Failed! Missing spec or version."
  exit 1
fi

target=".rpmbuild"

name="$(grep ^Name ${spec} | cut -f 2 -d : | xargs echo)"
release_macro="$(grep ^Release ${spec} | cut -f 2 -d : | xargs echo)"
release="$(rpm --eval '${release_macro}')"

srpm="${name}-${version}-${release}.src.rpm"

for i in name release_macro release srpm; do
  eval val="\$${i}"
  echo "$i: $val"
done

case "$clean" in
  [Yy][Ee][Ss]|[Tt][Rr][Uu][Ee])
    echo "Cleaning rpmbuild environment"
    [ -d "${target}" ] && rm -fr ${target}
    ;;
esac
[ ! -d "${target}" ] &&
  mkdir -p ${target}/{SOURCES,BUILD,RPMS,SRPMS,BUILDROOT,SPECS}

git archive --output=${target}/SOURCES/${name}-${version}.tar.gz \
  --prefix=${name}-${version}/ HEAD

rpmbuild --define "_topdir ${PWD}/${target}" \
  --define "version ${version}" -bs ${spec}

yum-builddep -y ${target}/SRPMS/${srpm}

rpmbuild --define "_topdir ${PWD}/${target}" \
  --define "version ${version}" -bb ${spec}

echo "rpms_path=${target}/RPMS" >> $GITHUB_OUTPUT
