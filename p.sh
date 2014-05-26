#!/bin/bash

#
# p - a friendly script launcher
#

#
# The MIT License (MIT)
# Copyright (c) 2014, Niko Usai <mogui@anche.no>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software
# and associated documentation files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or
# substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
# BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

function _p_comp
{
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  opts="$(ls $PSH_DIR)"

  case "${prev}" in
    help )
      COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
      return 0
    ;;

    ${PSH_CMD:-p})
      COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
      return 0
    ;;
  esac

  return 0

}


function _p() {

  #
  # source init file for configuration override
  #
  . ~/.pshrc 2> /dev/null

  # create scripts dir
  if [ ! -d $PSH_DIR ]; then
    mkdir $PSH_DIR
  fi

  #
  # Install default help command
  #
  if [ ! -f $PSH_DIR/help ]; then

######### HELP SCRIPT         #########
    cat << EOF > $PSH_DIR/help
#
#!/bin/bash
#
# ---
# This is the default command shipped with p.sh
# it gives help in how to use it
# adn help on scripts you install if you follow some simple rules
# just insert in your script an header like this one surrounded by 3 dash '-'
# to delimt it's content and then by issuing
# p help yourscript
# the header will be shown
# ----


if [ -z \$1 ]; then
  cat << AOF
NAME
  p - a friendly script launcher

USAGE
  p               # lists all installed script
  p [script]      # run the given script
  p help          # run the help script giving this help
  p help [script] # print the help of the given script (see notes)

INSTALLATION
  Put something like this in your $HOME/.bashrc:

  . /path/to/p.sh

  Optionally you can set these vars in a file named, $HOME/.pshrc:

  Set PSH_CMD to change the command name (default p).
  Set PSH_DIR to change dir where you store scripts (default $HOME/.pshdir).
  Set PSH_LIST to change the command that lists available scripts (default ls).

  this default help script is automatically installed,
  all you have to do now is put your scripts in $PSH_DIR !!

NOTE
  1. heavily inspired by z.sh
  2. to make a an help block in a new script just wrap it between --- just see the help script itself

AOF

else
  sed -n -e '/-\{3\}/,/-\{3\}/p' $PSH_DIR/\$1
fi

EOF
######### END OF HELP SCRIPT  #########

    chmod +x $PSH_DIR/help
  fi

  #
  # Main routine
  #
  case $1 in
    --complete)
      _p_comp
    ;;
    *)
      if [ -z $1 ]; then
          $PSH_LIST $PSH_DIR
      else
          cmd=$1
          shift
          $PSH_DIR/$cmd "$@"
      fi
      ;;
  esac

}


# configurable vars
PSH_DIR=~/.pshdir
PSH_LIST='ls'
alias ${PSH_CMD:-p}='_p'
complete -o default -F '_p_comp' ${PSH_CMD:-p}
