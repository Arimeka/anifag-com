#!/usr/bin/env bash

echo
echo "==> Set envs <=="

export FIXED_VERSION=`cat VERSION`
if [ -z "$VERSION" ]; then
  export VERSION=${FIXED_VERSION}
fi

export BUILD_TIME=${BUILD_TIME:-$(date -u '+%Y-%m-%dT%T%Z')}
export BUILD_GIT_HASH=${BUILD_GIT_HASH:-$(git rev-parse HEAD)}
export BUILD_GIT_BRANCH=${BUILD_GIT_BRANCH:-$(git rev-parse --abbrev-ref HEAD)}
export BUILD_GIT_STATE=${BUILD_GIT_STATE:-$(git diff --quiet --exit-code && echo 'clean' || echo 'dirty')}
export BUILD_USER_EMAIL=${BUILD_USER_EMAIL:-$(git config user.email)}
export BUILD_GO_VERSION=`cat GO_VERSION`
export BUILD_FLAGS="-X github.com/Arimeka/anifag-com/internal/pkg/version.Version=${VERSION}
              -X github.com/Arimeka/anifag-com/internal/pkg/version.BuildTime=${BUILD_TIME}
              -X github.com/Arimeka/anifag-com/internal/pkg/version.GitHash=${BUILD_GIT_HASH}
              -X github.com/Arimeka/anifag-com/internal/pkg/version.GitBranch=${BUILD_GIT_BRANCH}
              -X github.com/Arimeka/anifag-com/internal/pkg/version.UserMail=${BUILD_USER_EMAIL}
              -X github.com/Arimeka/anifag-com/internal/pkg/version.GitTreeState=${BUILD_GIT_STATE}
              -X github.com/Arimeka/anifag-com/internal/pkg/version.Hostname=${HOSTNAME}
              -X github.com/Arimeka/anifag-com/internal/pkg/version.Service=public@${CURRENT_GO_VERSION}"
