#!/bin/bash

## Disable security for downloaded application
sudo spctl --master-disable
defaults write com.apple.touchbar.agent PresentationModeGlobal functionKeys
## Enable Full key board access
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool false
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
## Enable detail save panel when saving a download file
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -boolean true
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Trackpad
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

defaults write com.apple.menuextra.battery ShowPercent -string "YES"
defaults write com.apple.menuextra.clock DateFormat -string "M\u6708d\u65e5(EEE)  H:mm:ss"

## Open spotlight by ctl + space
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "
<dict>
  <key>enabled</key>
  <true/>
  <key>value</key>
  <dict>
    <key>parameters</key>
    <array>
      <integer>65535</integer>
      <integer>49</integer>
      <integer>524288</integer>
    </array>
    <key>type</key>
    <string>standard</string>
  </dict>
</dict>"
## Change input language by command + space
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "
<dict>
  <key>enabled</key>
  <true/>
  <key>value</key>
  <dict>
    <key>parameters</key>
    <array>
      <integer>65535</integer>
      <integer>49</integer>
      <integer>1048576</integer>
    </array>
    <key>type</key>
    <string>standard</string>
  </dict>
</dict>"


# Dock
defaults write com.apple.dock autohide -bool false
defaults write com.apple.dock orientation -string "left"
killall Dock

# Finder
defaults write com.apple.finder AppleShowAllFiles -bool true
## Show full path
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
chflags nohidden ~/Library
sudo chflags nohidden /Volumes
killall Finder

# Screen Capture
mkdir -p ~/Desktop/screenCapture
defaults write com.apple.screencapture location ~/Desktop/screenCapture
killall SystemUIServer


