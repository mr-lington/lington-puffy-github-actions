# #!/bin/bash

# VERSION=""

# while getopts v: flag; do
#   case "${flag}" in
#     v) VERSION=${OPTARG};;
#   esac
# done

# git fetch --tags

# CURRENT_VERSION=$(git describe --abbrev=0 --tags 2>/dev/null || echo "v0.1.0")
# echo "Current Version: $CURRENT_VERSION"

# IFS='.' read -r MAJOR MINOR PATCH <<< "${CURRENT_VERSION#v}"

# case "$VERSION" in
#   major)
#     MAJOR=$((MAJOR+1)); MINOR=0; PATCH=0 ;;
#   minor)
#     MINOR=$((MINOR+1)); PATCH=0 ;;
#   patch)
#     PATCH=$((PATCH+1)) ;;
#   *)
#     echo "Usage: -v [major|minor|patch]"
#     exit 1 ;;
# esac

# NEW_TAG="v$MAJOR.$MINOR.$PATCH"
# echo "Creating tag $NEW_TAG"

# if git rev-parse "$NEW_TAG" >/dev/null 2>&1; then
#   echo "Tag already exists"
#   exit 0
# fi

# git tag "$NEW_TAG"
# git push origin "$NEW_TAG"

# echo "new-tag=$NEW_TAG" >> "$GITHUB_OUTPUT"


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
