#!/bin/bash

SCRIPTS_DIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)
PLIST_FILE=$SCRIPTS_DIR/../TTSDKDemo/Info.plist

BUILD_BRANCH=$(git symbolic-ref --short -q HEAD)
/usr/libexec/PlistBuddy -c "Set :buildBranch $BUILD_BRANCH" $PLIST_FILE

COMMIT_ID=$(git rev-parse --short -q HEAD)
/usr/libexec/PlistBuddy -c "Set :commitID $COMMIT_ID" $PLIST_FILE
