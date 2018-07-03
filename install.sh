#!/bin/bash

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

# homebrew [https://brew.sh/]
## Notification: required for OS X Lion 10.7 and below.
if [[ ! "$(which brew && brew help)" ]]; then
  echo 'install homebrew'
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# brew install
function brew_install() {
  curl -fsSL https://raw.githubusercontent.com/aha-oretama/MyMac/master/brewlist.csv | while read item
  do
    if [[ ! "$(brew list | grep ${item})" ]]; then
      echo "install ${item}"
      brew install "${item}"
    fi
  done
}
brew_install

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


# Apple install
function apple_install() {
  curl -fsSL https://raw.githubusercontent.com/aha-oretama/MyMac/master/apple.csv | while read line
  do
    title="$(echo ${line} | cut -d ',' -f 1)"
    id="$(echo ${line} | cut -d ',' -f 2)"

    if [[ ! "$(mas list | grep ${id})" ]]; then
      echo "install ${title}"
      mas install "${id}"
    fi
  done
}
apple_install

# dmg install
function dmg_install() {
  curl -fsSL https://raw.githubusercontent.com/aha-oretama/MyMac/master/dmg.csv | while read line
  do
    title="$(echo ${line} | cut -d ',' -f 1)"
    url="$(echo ${line} | cut -d ',' -f 2)"
    app="${title}.app"
    log="${title}.log"

    if [[ ! "$(ls /Applications/ | grep ${title})" ]]; then
      echo "install ${title}"
      wget "${url}" -O "${app}" -o "${log}"
      if [[ $? = 0 ]]; then
        hdiutil mount "${app}"
        volume="$(df | grep Typora | awk -F' ' '{print $9}')"
        cp -R "${volume}/${app}" /Applications/

        # tear down
        hdiutil detach "${volume}"
      else
        err "Cannot download ${url}. See ${log}."
      fi

      # tear down
      rm -f "${app}"
    fi
  done
}
dmg_install

# nodebrew [https://github.com/hokaccha/nodebrew]
if [[ ! "$(which nodebrew && nodebrew help)" ]]; then
  echo 'install nodebrew'
  curl -L git.io/nodebrew | perl - setup
  echo '# nodebrew' >> ~/.bashrc
  echo 'export PATH=$HOME/.nodebrew/current/bin:$PATH' >> ~/.bashrc
fi

# node [https://nodejs.org/ja/]
if [[ ! "$(which node && node --version)" ]]; then
  node_version="$(nodebrew ls-all | grep -E "^v" | tail -n 1)"
  echo "install node, version is ${node_version}"
  nodebrew install "${node_version}"
fi

# commitizen [https://github.com/commitizen/cz-cli]
if [[ ! "$(npm ls -g --depth=0 | grep commitizen)" ]]; then
  echo 'install commitizen'
  npm install -g commitizen cz-conventional-changelog
  echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc
fi
