#!/usr/bin/evn bash

# Cundle - Obj-C Libary Manager
# Implemented as a bash function
# To use source this file from your bash profile
#

# Auto detect the CUNDLE_DIR
if [ ! -d "$CUNDLE_DIR" ]; then
    export CUNDLE_DIR=$(cd $(dirname ${BASH_SOURCE[0]:-$0}); pwd)
fi

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

LIBDIR='SharedLib'

# Install a lib at current path
install() {
  if [ $# -ne 1 ]; then
    cundle help
    return
  fi

  [ "$NOCURL" ] && curl && return
  [ "$NOGIT" ] && git && return

  OPWD=`pwd`
  LIBNAME=$1
  LIBPATH=`echo $LIBNAME | awk -F / '{print $2}'`
  LIBPATH="$PWD/$LIBDIR/$LIBPATH"

  [ -d "$LIBPATH" ] && echo "$LIBNAME is already installed." && return

  if [ "`curl -Is "https://github.com/$LIBNAME" | grep '200 OK'`" != '' ]; then
    giturl="https://github.com/$LIBNAME.git"
    git clone $giturl $LIBPATH 2>/dev/null

    if [ -f "$LIBPATH/.gitmodules" ]; then
      export rvm_trust_rvmrcs_flag=1

      cd $LIBPATH
      git submodule update --init 2>/dev/null
      cd $OPWD

      export rvm_trust_rvmrcs_flag=0
    fi

    if [ -f "$LIBPATH/Cundlefile" ]; then
      install_path $LIBPATH
    fi
  fi
}

# Install libs at a given path, there must be a Cundle file at that path
install_path() {
  cundlefile="$1/Cundlefile"

  if [ ! -f $cundlefile ]; then
    cundle help
    return
  fi

  OPWD=`pwd`
  cd $1

  while read line
  do
    lib=`echo $line | awk '{print $2}' | tr -d "\""`
    install $lib
  done < $cundlefile

  cd $OPWD
}

# Update an install cundle
update() {
  OPWD=`pwd`
  for A in `ls $LIBDIR`
  do
    if [ -d "$OPWD/$LIBDIR/$A/.git" ]; then
      cd "$OPWD/$LIBDIR/$A"

      # Get the lib name
      lib=`git config -l | grep origin.url`
      if [[ $lib =~ $1 ]]; then
        echo "Updating $1 ..."
        git reset --hard HEAD 2> /dev/null
        git clean -fd 2> /dev/null
        git pull 2> /dev/null
      fi

      cd $OPWD
    fi
  done
}

update_path() {
  cundlefile="$1/Cundlefile"

  if [ ! -f $cundlefile ]; then
    cundle help
    return
  fi

  OPWD=`pwd`
  cd $1

  while read line
  do
    lib=`echo $line | awk '{print $2}' | tr -d "\""`
    update $lib
  done < $cundlefile

  cd $OPWD
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
      echo "    cundle remove <lib>            Remove a <lib>"
      echo "    cundle ls                      List installed libs"
      echo "    cundle install                 Download and install all libs defined in ./Cundlefile"
      echo "    cundle install <lib>           Download and install a <lib>"
      echo "    cundle update                  Use the latest code for all libs defined in ./Cundlefile"
      echo "    cundle update <lib>            Use the latest code for <lib> from git"
      echo
      echo "Example:"
      echo "    cundle install RestKit/RestKit Install latest version of RestKit"
      echo "    cundle remove RestKit/RestKit  Remove RestKit under SharedLib"
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

      OPWD=`pwd`
      for A in `ls $LIBDIR`
      do
        if [ -d "$OPWD/$LIBDIR/$A/.git" ]; then
          cd "$OPWD/$LIBDIR/$A"

          # Get the lib name
          lib=`git config -l | grep origin.url`
          if [[ $lib =~ $2 ]]; then
            rm -rf "$OPWD/$LIBDIR/$A" 2> /dev/null
            echo "Removed $2"
          fi

          cd $OPWD
        fi
      done
    ;;
    "ls" | "list" )
      [ $# -ne 1 ] && cundle help && return

      OPWD=`pwd`
      echo "Installed libs:"
      for A in `ls $LIBDIR`
      do
        if [ -d "$OPWD/$LIBDIR/$A/.git" ]; then
          cd "$OPWD/$LIBDIR/$A"
          # Get the lib name
          lib=`git config -l | grep origin.url |sed -e 's/.*github.com\/\(.*\).git/\1/g'`
          if [ $lib ]; then echo "✓ $lib"; fi
          cd $OPWD
        fi
      done
    ;;
    * )
      cundle help
    ;;
  esac
}
