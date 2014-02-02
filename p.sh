#!/bin/bash

#
# easy script access
#

function _p_comp
{
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  opts="$(ls $_PSH_DIR)"

  case "${prev}" in
    help )
      COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
      return 0
    ;;

    ${_PSH_CMD:-p})
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
  if [ ! -d $_PSH_DIR ]; then
    mkdir $_PSH_DIR
  fi

  #
  # Install default help command
  #
  if [ ! -f $_PSH_DIR/help ]; then

######### HELP SCRIPT         #########
    cat << EOF > $_PSH_DIR/help
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

  Set $_PSH_CMD to change the command name (default p).
  Set $_PSH_DIR to change dir where you store scripts (default $HOME/.pshdir).
  Set $_PSH_LIST to change the command that lists available scripts (default ls).

  this default help script is automatically installed,
  all you have to do now is put your scripts in $_PSH_DIR !!

NOTE
  heavily inspired by z.sh
AOF

else
  sed -n -e '/-\{3\}/,/-\{3\}/p' $_PSH_DIR/\$1
fi

EOF
######### END OF HELP SCRIPT  #########

    chmod +x $_PSH_DIR/help
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
          $_PSH_LIST $_PSH_DIR
      else
          cmd=$1
          shift
          $_PSH_DIR/$cmd "$@"
      fi
      ;;
  esac

}


# configurable vars
_PSH_DIR=~/.pshdir
_PSH_LIST='ls'
alias ${_PSH_CMD:-p}='_p'
complete -o default -F '_p_comp' ${_PSH_CMD:-p}