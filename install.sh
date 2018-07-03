# homebrew [https://brew.sh/]
## Notification: required for OS X Lion 10.7 and below.
if [[ ! "$(which brew && brew help)" ]]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# mas-cli [https://github.com/mas-cli/mas]
if [[ ! "$(brew list | grep mas)" ]]; then 
  brew install mas
fi
mas outdated

# The Unarchiver [https://itunes.apple.com/jp/app/the-unarchiver/id425424353]
if [[ ! "$(mas list | grep 425424353)" ]; then
  mas install 425424353
fi
