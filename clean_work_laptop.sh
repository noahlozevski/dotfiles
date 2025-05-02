#!/usr/bin/env bash
set -euo pipefail

# --------------------------
# Helper functions
# --------------------------
remove_directories_greater_than_mb() {
    threshold_size_mb=$1
    search_path=$2
    find "$search_path" -type d -mindepth 1 -maxdepth 1 -exec du -sm {} + | while read size path; do
        if [ "$size" -gt "$threshold_size_mb" ]; then
            echo "Deleting directory $path which is $size MB"
            rm -rf "$path"
        fi
    done
}

delete_all_of_file_type() {
    file_type=$1
    search_path=$2
    find "$search_path" -type f -name "*.$file_type" -exec rm -v {} \;
}

delete() {
    path=$1
    if [ -e "$path" ]; then
        echo "Deleting $path"
        rm -rfv "$path"
    fi
}

# --------------------------
# Core system & dev caches
# --------------------------
delete "$HOME/Library/Application Support/Slack/logs/"

# Xcode
delete "$HOME/Library/Developer/Xcode/DerivedData"
delete "$HOME/Library/Developer/CoreSimulator/Caches"
delete "$HOME/Library/Developer/Xcode/UserData/Previews"
delete "$HOME/Library/Developer/Xcode/Archives"      # Xcode Archives

# CocoaPods
delete "$HOME/.cocoapods"                            # global CocoaPods state
delete "$HOME/.cocoapods/repos"                      # repos cache
delete "$HOME/Library/Caches/CocoaPods"              # CocoaPods cache
pod cache clean --all                                # clear any remaining Pod cache

# CoreSimulator Device Support (if you want to wipe old device symbols)
delete "$HOME/Library/Developer/Xcode/iOS DeviceSupport"

# JetBrains, pip, brew, etc.
delete "$HOME/Library/Caches/JetBrains"
delete "$HOME/Library/Caches/pip"
delete "$HOME/Library/Caches/brazil"
delete "$HOME/Library/Caches/Sourcery"
delete "$HOME/Library/Caches/Google"
delete "$HOME/Library/Caches/com.spotify.client"

delete "$HOME/Library/Containers/com.apple.CoreDevice.CoreDeviceService/Data/Library/Caches"
delete "$HOME/Library/Group Containers/UBF8T346G9.Office/Outlook/Outlook 15 Profiles/Main Profile/Caches"

delete "$HOME/Library/Messages/Caches"

delete "$HOME/.gradle/daemon"
delete "$HOME/.gradle/brazil-gradle-dists"
delete "$HOME/.gradle/.tmp"
delete "$HOME/.gradle/wrapper"
delete "$HOME/.gradle/caches"

delete "$HOME/brazil-pkg-cache/s3BinaryFiles"
delete "$HOME/brazil-pkg-cache/logs"
delete "$HOME/brazil-pkg-cache/tmp"

delete "$HOME/.cache"

# --------------------------
# Node / JS / RN / Expo caches
# --------------------------
# npm & yarn
npm cache clean --force --verbose
if command -v yarn &>/dev/null; then
  yarn cache clean --force
fi

# Watchman (used by Metro)
if command -v watchman &>/dev/null; then
  echo "Clearing Watchman watches and shutting down server"
  watchman watch-del-all || true
  watchman shutdown-server || true
fi

# Metro / RN packager caches
TMPDIR=${TMPDIR:-/tmp}
delete "$TMPDIR/metro-*"
delete "$TMPDIR/haste-map-*"
delete "$TMPDIR/react-*"

# Expo
delete "$HOME/.expo"
delete "$HOME/.expo/cache"
delete "$HOME/.expo-shared"

# --------------------------
# Downloads & home logs
# --------------------------
remove_directories_greater_than_mb 500 "$HOME/Library/Caches"
remove_directories_greater_than_mb 100 "$HOME/Library/Logs"

delete_all_of_file_type apk "$HOME/Downloads"
delete_all_of_file_type ipa "$HOME/Downloads"
delete_all_of_file_type dmg "$HOME/Downloads"

# --------------------------
# Other tool cleanups
# --------------------------
brew cleanup --prune=all --verbose

./clean_all_workspaces.sh

brazil-package-cache stop
echo -n "Cleaning pkg cache ..." && brazil-package-cache clean --debug --days 0 --keepCacheHours 0 --percent 0 2>&1

echo -n "Cleaning toolbox ..." && toolbox clean 2>&1
