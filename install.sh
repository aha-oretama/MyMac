#!/bin/bash


# homebrew [https://brew.sh/]
## Notification: required for OS X Lion 10.7 and below.
if [[ ! "$(which brew && brew help)" ]]; then
  echo 'install homebrew'
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi


# mas-cli [https://github.com/mas-cli/mas]
if [[ ! "$(brew list | grep mas)" ]]; then
  echo 'install mas-cli'
  brew install mas
fi
mas outdated

## change cli from gui after fix https://github.com/mas-cli/mas/issues/107
# echo "input your Apple ID"
# read itunes_user
# echo "${itunes_user}"
# mas signin "${itunes_user}"
echo -e "\nPlease log in to the app store..."

open -a "/Applications/App Store.app"

until (mas account > /dev/null);
do
  sleep 3
done


# The Unarchiver [https://itunes.apple.com/jp/app/the-unarchiver/id425424353]
if [[ ! "$(mas list | grep 425424353)" ]]; then
  echo 'install The Unarchiver'
  mas install 425424353
fi

# nodebrew [https://github.com/hokaccha/nodebrew]
if [[ ! "$(which nodebrew && nodebrew help)" ]]; then
  echo 'install nodebrew'
  curl -L git.io/nodebrew | perl - setup
  echo '# nodebrew' >> ~/.bashrc
  echo 'export PATH=$HOME/.nodebrew/current/bin:$PATH' >> ~/.bashrc
fi

# node [https://nodejs.org/ja/]
if [[ ! "$(which node && node --version) ]]; then
  local node_version="$(nodebrew ls-all | grep -E "^v" | tail -n 1)"
  echo "install node, version is ${node_version}"
  nodebrew install "${node_version}"
fi

# commitizen [https://github.com/commitizen/cz-cli]
if [[ ! "$(which cz)" ]]; then
  echo 'install commitizen'
  npm install -g commitizen cz-conventional-changelog
  echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc
fi
