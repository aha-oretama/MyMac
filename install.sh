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
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
      brew install "${item}" </dev/null
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
    if [[ ! "$(brew list --cask | grep ${item})" && ! `ls /Applications/ | grep -i "${tmp}"` ]]; then
      infoInstalling "${item}"
      brew install --cask "${item}"
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
  ## Need to signin via GUI: https://github.com/mas-cli/mas#%EF%B8%8F-known-issues
  echo "Sign in your Apple ID via App Store."
  mas open
  read -p "Hit enter: "

  curl -H 'Cache-Control: no-cache' -fsSL 'https://raw.githubusercontent.com/aha-oretama/MyMac/master/apple.csv' | while read line
  do
    title="$(echo ${line} | cut -d ',' -f 1 | tr -s ' ')"
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

function anyenv_install() {
  yes | anyenv install --init
  curl -H 'Cache-Control: no-cache' -fsSL 'https://raw.githubusercontent.com/aha-oretama/MyMac/master/anyenv.csv' | while read item
  do
    if [[ ! "$(anyenv version | grep ${item})" ]]; then
      infoInstalling "${item}"
      anyenv install "${item}"
      infoInstalled "${item}"
    else
      infoAlreadyInstalled "${item}"
    fi
  done
}

homebrew_install
brew_install
brew_cask_install
apple_install
anyenv_install
