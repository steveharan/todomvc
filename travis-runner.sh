#!/bin/bash
set -o pipefail

if [ "$TRAVIS_BRANCH" = "master" ] && [ "$TRAVIS_PULL_REQUEST" = "false" ]
then
  git submodule add -b gh-pages https://${GH_OAUTH_TOKEN}@github.com/${GH_OWNER}/${GH_PROJECT_NAME} site > /dev/null 2>&1
  cd site
  if git checkout gh-pages; then git checkout -b gh-pages; fi
  git rm -r .
  cp -R ../dist/* .
  cp ../dist/.* .
  git add -f .
  git config user.email 'travis@rdrei.net'
  git config user.name 'TasteBot'
  git commit -am 'update the build files for gh-pages [ci skip]'
  # Any command that using GH_OAUTH_TOKEN must pipe the output to /dev/null to not expose your oauth token
  git push https://${GH_OAUTH_TOKEN}@github.com/${GH_OWNER}/${GH_PROJECT_NAME} HEAD:gh-pages > /dev/null 2>&1
else
  changes=$(./util/get-changes.sh) && \

  if [ "${#changes}" = 0 ]
  then
    exit 0
  else
    cd tests && \
    echo $changes | xargs ./run.sh && \
    cd ../browser-tests && \
    echo $changes | xargs ./run.sh
  fi

  exit $?
fi
