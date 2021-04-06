#!/usr/bin/env bash

#set -eoup

function mac::ensure-upstream() {
  if [ ! -d mac-dev-playbook ]; then
    git clone https://github.com/geerlingguy/mac-dev-playbook 
    cd mac-dev-playbook
    git remote rename origin upstream
    ansible-galaxy install -r requirements.yml
  else
    cd mac-dev-playbook
    git fetch --all
    git rebase upstream master
    cd -
  fi
}

function mac::ensure-dependencies() {
  xcode-select --install || true
  /usr/bin/env bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew install ansible mas
}

function mac::apply() {
    cd mac-dev-playbook
    [ ! -f config.yml ] && ln -s ../config.yml .
    ansible-playbook main.yml -i inventory --ask-become-pass
}

function mac::setup() {
    mac::ensure-dependencies
    mac::ensure-upstream
    mac::apply
}
