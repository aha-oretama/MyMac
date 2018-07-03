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

