#!/usr/bin/evn bash

# Cundle - Obj-C Libary Manager
# Implemented as a bash function
# To use source this file from your bash profile
#

# Auto detect the CUNDLE_DIR
# if [ ! -d "$CUNDLE_DIR" ]; then
#     export CUNDLE_DIR=$(cd "$(dirname ${BASH_SOURCE[0]:-$0})"; pwd)
# fi

# Check url
if [ ! `which curl` ]; then
  NOCURL='nocurl'
  curl() { echo 'Need curl to proceed.' >&2; }
fi

# Check git
if [ ! `which git` ]; then
  NOGIT='nogit'
  git() { echo 'Need git to proceed.' >&2; }
fi

LIB_DIR_NAME='SharedLib'

# Install a lib at current path
install() {
  if [ $# -ne 1 ]; then
    cundle help
    return
  fi

  [ "$NOCURL" ] && curl && return
  [ "$NOGIT" ] && git && return

  local old_path=`pwd`
  local lib_name=${1//.git/}
  local lib_path="$PWD/$LIB_DIR_NAME/`echo ${lib_name##*/}`"

  [ -d "$lib_path" ] && echo "$lib_path is already installed." && return

  if [[ $lib_name == http:* || $lib_name == https:* || $lib_name == git@* ]]; then
    local git_url=$lib_name
  else
    local git_url="https://github.com/$lib_name"
  fi

  git clone $git_url $lib_path 2>/dev/null

  if [ -d "$lib_path" ]; then
    if [ -f "$lib_path/.gitmodules" ]; then
      cd "$lib_path"
      git submodule update --init 2>/dev/null
      cd "$old_path"
    fi

    if [ -f "$lib_path/Cundlefile" ]; then
      install_path $lib_path
    fi
  fi
}

# Install libs at a given path, there must be a Cundle file at that path
install_path() {
  local cundlefile="$1/Cundlefile"

  if [ ! -f $cundlefile ]; then
    cundle help
    return
  fi

  local old_path=`pwd`
  cd "$1"

  while read line
  do
    lib=`echo $line | awk '{print $2}' | tr -d "\""`
    install $lib
  done < $cundlefile

  cd "$old_path"
}

# Update an install cundle
update() {
  local old_path=`pwd`
  for lib in `ls $LIB_DIR_NAME`
  do
    if [ -d "$old_path/$LIB_DIR_NAME/$lib/.git" ]; then
      cd "$old_path/$LIB_DIR_NAME/$lib"

      # Get the lib name
      repo=`git config -l | grep origin.url | grep -o "[^/]*$"`
      if [[ $1 == *$repo || $1 == *$repo.git ]]; then
        echo "Updating $1 ..."
        git reset --hard HEAD 2> /dev/null
        git clean -fd 2> /dev/null
        git pull 2> /dev/null
      fi

      cd "$old_path"
    fi
  done
}

update_path() {
  local cundlefile="$1/Cundlefile"

  if [ ! -f $cundlefile ]; then
    cundle help
    return
  fi

  local old_path=`pwd`
  cd "$1"

  while read line
  do
    lib=`echo $line | awk '{print $2}' | tr -d "\""`
    update $lib
  done < $cundlefile

  cd "$old_path"
}

cundle()
{
  if [ $# -lt 1 ]; then
    cundle help
    return
  fi

  case $1 in
    "help" )
      echo
      echo "Cundle - Obj-C Libary Manager"
      echo
      echo "Usage:"
      echo "    cundle help                    Show this message"
      echo "    cundle install                 Download and install all libs defined in ./Cundlefile"
      echo "    cundle install <lib>           Download and install a <lib>"
      echo "    cundle update                  Use the latest code for libs defined in ./Cundlefile"
      echo "    cundle update <lib>            Use the latest code for <lib> from git"
      echo "    cundle ls                      List installed libs"
      echo "    cundle remove <lib>            Remove a <lib>"
      echo
      echo "Example:"
      echo "    cundle install enormego/EGOCache"
      echo
    ;;
    "install" )
      if [ $# -eq 1 ]; then
        install_path `pwd`
      elif [ $# -eq 2 ]; then
        install $2
      else
        cundle help && return
      fi
    ;;
    "update" )
      if [ $# -eq 1 ]; then
        update_path `pwd`
      elif [ $# -eq 2 ]; then
        update $2
      else
        cundle help && return
      fi
    ;;
    "remove" )
      [ $# -ne 2 ] && cundle help && return

      local old_path=`pwd`
      for lib in `ls $LIB_DIR_NAME`
      do
        if [ -d "$old_path/$LIB_DIR_NAME/$lib/.git" ]; then
          cd "$old_path/$LIB_DIR_NAME/$lib"

          # Get the lib name
          liburl=`git config -l | grep origin.url`
          if [[ $liburl =~ $2 ]]; then
            rm -rf "$old_path/$LIB_DIR_NAME/$lib"
            echo "Removed $2"
          fi

          cd "$old_path"
        fi
      done
    ;;
    "ls" | "list" )
      [ $# -ne 1 ] && cundle help && return

      local old_path=`pwd`

      [ ! -d "$old_path/$LIB_DIR_NAME" ] && echo "No libs installed" && return

      echo "Installed libs under $old_path/$LIB_DIR_NAME:"
      for lib in `ls $LIB_DIR_NAME`
      do
        if [ -d "$old_path/$LIB_DIR_NAME/$lib/.git" ]; then
          cd "$old_path/$LIB_DIR_NAME/$lib"
          # Get the lib name
          repo=`git config -l | grep origin.url | grep -o "[^/]*$"`
          if [ $repo ]; then echo "✓ $lib"; fi
          cd "$old_path"
        fi
      done
    ;;
    * )
      cundle help
    ;;
  esac
}
