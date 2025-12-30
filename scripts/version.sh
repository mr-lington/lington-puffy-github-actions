#!/bin/bash
VERSION=""

while getopts v: flag
do
  case "${flag}" in
    v) VERSION=${OPTARG};;
  esac
done

git fetch --prune --unshallow 2>/dev/null
CURRENT_VERSION=$(git describe --abbrev=0 --tags 2>/dev/null)

if [[ -z "$CURRENT_VERSION" ]]; then
  CURRENT_VERSION="v0.1.0"
fi

echo "Current Version: $CURRENT_VERSION"

IFS='.' read -r VNUM1 VNUM2 VNUM3 <<< "${CURRENT_VERSION#v}"

case "$VERSION" in
  major)
    VNUM1=$((VNUM1+1)); VNUM2=0; VNUM3=0 ;;
  minor)
    VNUM2=$((VNUM2+1)); VNUM3=0 ;;
  patch)
    VNUM3=$((VNUM3+1)) ;;
  *)
    echo "Invalid version type"
    exit 1 ;;
esac

NEW_TAG="v$VNUM1.$VNUM2.$VNUM3"
echo "Creating tag $NEW_TAG"

git tag "$NEW_TAG"
git push origin "$NEW_TAG"
