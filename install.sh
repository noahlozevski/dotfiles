#!/bin/zsh


# mac sed sucks
brew install gnu-sed

# essential tools
brew install stow


# skagent prioritizer
stow xcode -t ~/ --no-folding
launchctl load ~/Library/LaunchAgents/com.lozevski.renice_skagent.plist
