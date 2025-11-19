#!/usr/bin/env bash

set -ou pipefail
# allow script to fail on any command
set +e

# --------------------------
# Configuration
# --------------------------
LOG_FILE="$HOME/cleanup.log"
: >"$LOG_FILE"

TASKS=(
  "Slack Logs"
  "Xcode Caches"
  "CocoaPods/SwiftPM"
  "CoreDevice/Outlook/Messages"
  "JetBrains & pip"
  "Gradle & BrazilPKG"
  "Node/JS/Expo"
  "Downloads & Logs"
  "Homebrew & Toolbox"
  "Workspaces & ACME"
  "Clang & ccache"
)

NUM_TASKS=${#TASKS[@]}
ROWS=$(tput lines)
SCROLL_END=$(( ROWS - NUM_TASKS ))

# --------------------------
# Terminal setup
# --------------------------
clear
# restrict scroll region to lines 1..SCROLL_END
printf '\033[1;%dr' "$SCROLL_END"

# draw initial empty bars at bottom
for i in "${!TASKS[@]}"; do
  row=$(( SCROLL_END + i + 1 ))
  tput cup "$row" 0
  printf "%-30s [--------------------]   0%%\n" "${TASKS[i]}"
done

# return cursor to top scroll region
tput cup 0 0

# --------------------------
# Helpers
# --------------------------
log() {
  echo "$@" | tee -a "$LOG_FILE"
}

update_progress() {
  local idx=$1 percent=$2
  local barlen=20
  local filled=$(( percent * barlen / 100 ))
  local empty=$(( barlen - filled ))
  local bar
  bar="$(printf "%*s" "$filled" '' | tr ' ' '#')"
  bar+=$(printf "%*s" "$empty" '' | tr ' ' '-')
  local row=$(( SCROLL_END + idx + 1 ))
  tput cup "$row" 0
  printf "%-30s [%s] %3d%%\n" "${TASKS[idx]}" "$bar" "$percent"
  # restore cursor into scroll region
  tput cup $(( SCROLL_END - 1 )) 0
}

remove_directories_greater_than_mb() {
  local threshold=$1 path=$2
  find "$path" -type d -mindepth 1 -maxdepth 1 -exec du -sm {} + \
    | while read size dir; do
        log "[${FUNCNAME[0]}] Checking $dir ($size MB)"
        if [ "$size" -gt "$threshold" ]; then
          log "[${FUNCNAME[0]}] Deleting $dir"
          rm -rf "$dir"
        fi
      done
}

delete_all_of_file_type() {
  local ext=$1 path=$2
  find "$path" -type f -name "*.$ext" -print -exec rm -v {} \; | while read line; do
    log "[${FUNCNAME[0]}] $line"
  done
}

run_task() {
  local idx=$1 name="$2"; shift 2
  update_progress "$idx" 0
  log "=== START: $name ==="
  "$@" &>>"$LOG_FILE"
  local rc=$?
  if [ $rc -eq 0 ]; then
    log "=== DONE:  $name ==="
    update_progress "$idx" 100
  else
    log "!!! FAIL:  $name (exit $rc) ==="
    update_progress "$idx" 100
  fi
}

# --------------------------
# Cleanup functions
# --------------------------
cleanup_slack() {
  log "[Slack] Deleting Slack logs"
  rm -rf "$HOME/Library/Application Support/Slack/logs/"
}

cleanup_xcode() {
  local paths=(
    "$HOME/Library/Developer/Xcode/DerivedData"
    "$HOME/Library/Developer/CoreSimulator/Caches"
    "$HOME/Library/Developer/Xcode/UserData/Previews"
    "$HOME/Library/Developer/Xcode/Archives"
    "$HOME/Library/Developer/Xcode/iOS DeviceSupport"
  )
  local total=${#paths[@]}
  for i in "${!paths[@]}"; do
    log "[Xcode] Deleting ${paths[i]}"
    rm -rf "${paths[i]}"
    update_progress 1 $(( (i+1)*100/total ))
  done
  log "[Xcode] Cleaning extra module & cache dirs"
  rm -rf ~/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/*
  rm -rf ~/Library/Caches/com.apple.dt.Xcode/*
  update_progress 1 100
}

cleanup_cocoapods_swiftpm() {
  local steps=(
    ".cocoapods"
    ".cocoapods/repos"
    "Library/Caches/CocoaPods"
  )
  local total=${#steps[@]}
  for i in "${!steps[@]}"; do
    log "[CocoaPods] Deleting $HOME/${steps[i]}"
    rm -rf "$HOME/${steps[i]}"
    update_progress 2 $(( (i+1)*80/total ))
  done
  log "[CocoaPods] pod cache clean"
  pod cache clean --all
  update_progress 2 100
}

cleanup_coredevice_outlook_messages() {
  local paths=(
    "$HOME/Library/Containers/com.apple.CoreDevice.CoreDeviceService/Data/Library/Caches"
    "$HOME/Library/Group Containers/UBF8T346G9.Office/Outlook/Outlook 15 Profiles/Main Profile/Caches"
    "$HOME/Library/Messages/Caches"
  )
  local total=${#paths[@]}
  for i in "${!paths[@]}"; do
    log "[CoreDevice] Deleting ${paths[i]}"
    rm -rf "${paths[i]}"
    update_progress 3 $(( (i+1)*100/total ))
  done
}

cleanup_jetbrains_pip_misc() {
  local paths=(
    "$HOME/Library/Caches/JetBrains"
    "$HOME/Library/Caches/pip"
    "$HOME/Library/Caches/brazil"
    "$HOME/Library/Caches/Sourcery"
    "$HOME/Library/Caches/Google"
    "$HOME/Library/Caches/com.spotify.client"
  )
  local total=${#paths[@]}
  for i in "${!paths[@]}"; do
    log "[Caches] Deleting ${paths[i]}"
    rm -rf "${paths[i]}"
    update_progress 4 $(( (i+1)*100/total ))
  done
}

cleanup_gradle_brazilpkg() {
  log "[BrazilPKG] Stopping package cache daemons.."
  brazil-package-cache stop
  brazil-wire-ctl stop
  local items=(
    "$HOME/.gradle/daemon"
    "$HOME/.gradle/brazil-gradle-dists"
    "$HOME/.gradle/.tmp"
    "$HOME/.gradle/wrapper"
    "$HOME/.gradle/caches"
    "$HOME/brazil-pkg-cache/s3BinaryFiles"
    "$HOME/brazil-pkg-cache/logs"
    "$HOME/brazil-pkg-cache/tmp"
  )
  local total=$(( ${#items[@]} + 1 ))
  for i in "${!items[@]}"; do
    log "[Gradle] Deleting ${items[i]}"
    rm -rf "${items[i]}"
    update_progress 5 $(( (i+1)*100/total ))
  done
  log "[BrazilPKG] Cleaning pkg cache"
  rm -rf ~/brazil-pkg-cache/packages
  brazil-package-cache clean --days=0 --debug
  update_progress 5 100
  log "[BrazilPKG] Cleaning brazil-wire-ctl cache"
  brazil-wire-ctl clean-cache
  update_progress 5 100
}

cleanup_node_js_expo() {
  local total=7 i=0
  ((i++)); log "[Node] npm cache clean"; npm cache clean --force --verbose; update_progress 6 $((i*100/total))
  ((i++)); if command -v yarn &>/dev/null; then log "[Node] yarn cache clean"; yarn cache clean --force; else log "[Node] yarn not found"; fi; update_progress 6 $((i*100/total))
  ((i++)); if command -v watchman &>/dev/null; then log "[Watchman] clearing"; watchman watch-del-all || true; watchman shutdown-server || true; else log "[Watchman] not installed"; fi; update_progress 6 $((i*100/total))
  ((i++)); TMPDIR=${TMPDIR:-/tmp}; log "[Node] deleting tmp caches"; rm -rf "$TMPDIR"/metro-* "$TMPDIR"/haste-map-* "$TMPDIR"/react-*; update_progress 6 $((i*100/total))
}

cleanup_downloads() {
  local total=5 i=0
  ((i++)); log "[Downloads] remove >500MB"; remove_directories_greater_than_mb 500 "$HOME/Library/Caches"; update_progress 7 $((i*100/total))
  ((i++)); log "[Downloads] remove >100MB"; remove_directories_greater_than_mb 100 "$HOME/Library/Logs"; update_progress 7 $((i*100/total))
  ((i++)); log "[Downloads] delete *.apk"; delete_all_of_file_type apk "$HOME/Downloads"; update_progress 7 $((i*100/total))
  ((i++)); log "[Downloads] delete *.ipa"; delete_all_of_file_type ipa "$HOME/Downloads"; update_progress 7 $((i*100/total))
  ((i++)); log "[Downloads] delete *.dmg"; delete_all_of_file_type dmg "$HOME/Downloads"; update_progress 7 $((i*100/total))
}

cleanup_brew_toolbox() {
  local total=2 i=0
  ((i++)); log "[Brew] brew cleanup"; brew cleanup --prune=all --verbose; update_progress 8 $((i*100/total))
  ((i++)); log "[Toolbox] toolbox clean"; toolbox clean 2>&1; update_progress 8 $((i*100/total))
}

cleanup_workspaces_node_modules_acme() {
  local total=3 i=0
  ((i++)); log "[Workspaces] clean_all_workspaces.sh"; ./clean_all_workspaces.sh; update_progress 9 $((i*100/total))
  ((i++)); log "[Workspaces] deleting node_modules"; find "$HOME/workplace" -type d -name 'node_modules' -prune -exec rm -rfv '{}' +; update_progress 9 $((i*100/total))
  ((i++)); log "[ACME] deleting cache"; sudo rm -rf "/usr/local/amazon/var/acme/cache"; update_progress 9 $((i*100/total))
}

cleanup_clang_caches() {
  local total=3 i=0
  ((i++)); log "[Clang] cleaning ModuleCache"; sudo find /private/var/folders -type d -path '*/C/clang/ModuleCache*' -exec rm -rf {} +; update_progress 10 $((i*100/total))
  ((i++)); log "[Clang] cleaning clangd indexes"; rm -rf "$HOME/.cache/clangd"; find . -type d -path '*/.cache/clangd/index' -exec rm -rf {} +; update_progress 10 $((i*100/total))
  ((i++)); log "[Clang] cleaning ccache"; rm -rf "$HOME/.ccache"; update_progress 10 $((i*100/total))
}

# --------------------------
# Run tasks in parallel
# --------------------------
run_task 0  "Slack Logs"                cleanup_slack                &
run_task 1  "Xcode Caches"              cleanup_xcode                &
run_task 2  "CocoaPods/SwiftPM"         cleanup_cocoapods_swiftpm    &
run_task 3  "CoreDevice/Outlook/Messages" cleanup_coredevice_outlook_messages &
run_task 4  "JetBrains & pip"           cleanup_jetbrains_pip_misc   &
run_task 5  "Gradle & BrazilPKG"        cleanup_gradle_brazilpkg     &
run_task 6  "Node/JS/Expo"              cleanup_node_js_expo         &
run_task 7  "Downloads & Logs"          cleanup_downloads            &
run_task 8  "Homebrew & Toolbox"        cleanup_brew_toolbox         &
run_task 9  "Workspaces & ACME"         cleanup_workspaces_node_modules_acme &
run_task 10 "Clang & ccache"            cleanup_clang_caches         &

wait

# restore full scroll region
printf '\033[r'
log "✅ All cleanup tasks completed."
