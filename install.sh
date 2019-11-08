#!/bin/bash

infoInstalling() {
  echo "$(tput setaf 2)Installing $@ ...$(tput sgr0)"
}

infoInstalled() {
  echo "$(tput setaf 2)Finished installing $@ ✔︎$(tput sgr0)"
}

infoAlreadyInstalled() {
  echo "$(tput setaf 2)Already installed $@ ✔︎$(tput sgr0)"
}

# homebrew [https://brew.sh/]
function homebrew_install() {
  ## Notification: required for OS X Lion 10.7 and below.
  if [[ ! "$(which brew && brew help)" ]]; then
    infoInstalling 'homebrew'
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    infoInstalled 'homebrew'
  else
    infoAlreadyInstalled 'homebrew'
  fi
}

# brew install
function brew_install() {
  curl -H 'Cache-Control: no-cache' -fsSL 'https://raw.githubusercontent.com/aha-oretama/MyMac/master/brew_list.csv' | while read item
  do
    if [[ ! "$(brew list | grep ${item})" ]]; then
      infoInstalling "${item}"
      brew install "${item}"
      infoInstalled "${item}"
    else
      infoAlreadyInstalled "${item}"
    fi
  done
}

# brew cask install
function brew_cask_install() {
  curl -H 'Cache-Control: no-cache' -fsSL 'https://raw.githubusercontent.com/aha-oretama/MyMac/master/brew_cask_list.csv' | while read item
  do
    tmp="$(echo ${item} | tr '-' ' ')"
    if [[ ! "$(brew cask list | grep ${item})" && ! `ls /Applications/ | grep -i "${tmp}"` ]]; then
      infoInstalling "${item}"
      brew cask install "${item}"
      infoInstalled "${item}"
    else
      infoAlreadyInstalled "${item}"
    fi
  done
}

# Apple install
## Notification: App's title may include space.
function apple_install() {
  # mas-cli [https://github.com/mas-cli/mas]
  ## change cli from gui after fix https://github.com/mas-cli/mas/issues/107
  # echo "input your Apple ID"
  # read itunes_user
  # echo "${itunes_user}"
  # mas signin "${itunes_user}"
  if [[ ! "$(mas account)" ]]; then
    echo -e "\nPlease log in to the app store..."
    open -a "/Applications/App Store.app"

    until (mas account > /dev/null);
    do
      sleep 3
    done
  fi

  curl -H 'Cache-Control: no-cache' -fsSL 'https://raw.githubusercontent.com/aha-oretama/MyMac/master/apple.csv' | while read line
  do
    title="$(echo ${line} | cut -d ',' -f 1 | tr -d [:space:])"
    id="$(echo ${line} | cut -d ',' -f 2)"

    if [[ ! "$(mas list | grep ${id})" && ! (`ls /Applications/ | grep -i "${title}"`) ]]; then
      infoInstalling "${title}"
      mas install "${id}"
      infoInstalled "${title}"
    else
      infoAlreadyInstalled "${title}"
    fi
  done
}

# node [https://nodejs.org/ja/]
function node_install() {
  if [[ ! "$(which node && node --version)" ]]; then
    node_version="$(nodebrew ls-all | grep -E "^v" | tail -n 1)"
    infoInstalling "node, version is ${node_version}"
    nodebrew install "${node_version}"
  else
    infoAlreadyInstalled "node, version is $(node --version)"
  fi
}

# commitizen [https://github.com/commitizen/cz-cli]
function npm_global_install() {
  if [[ ! "$(npm ls -g --depth=0 | grep commitizen)" ]]; then
    infoInstalling 'commitizen'
    npm install -g commitizen cz-conventional-changelog
  else
    infoAlreadyInstalled "commitizen"
  fi
}

homebrew_install
brew_install
brew_cask_install
apple_install
node_install
npm_global_install
