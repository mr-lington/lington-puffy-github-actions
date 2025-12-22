
#!/bin/bash
set -e

VERSION_TYPE=$1

if [[ -z "$VERSION_TYPE" ]]; then
  echo "Usage: ./release.sh [major|minor|patch]"
  exit 1
fi

git fetch --tags

CURRENT_VERSION=$(git describe --abbrev=0 --tags 2>/dev/null || echo "v0.1.0")
echo "Current version: $CURRENT_VERSION"

IFS='.' read -r V1 V2 V3 <<< "${CURRENT_VERSION#v}"

case "$VERSION_TYPE" in
  major)
    V1=$((V1+1)); V2=0; V3=0 ;;
  minor)
    V2=$((V2+1)); V3=0 ;;
  patch)
    V3=$((V3+1)) ;;
  *)
    echo "Invalid version type"
    exit 1
    ;;
esac

NEW_TAG="v$V1.$V2.$V3"
echo "Creating tag $NEW_TAG"

git tag "$NEW_TAG"
git push origin "$NEW_TAG"
