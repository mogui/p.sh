  
    NAME
      p - a friendly script launcher

    USAGE
      p               # lists all installed script
      p [script]      # run the given script
      p help          # run the help script giving this help
      p help [script] # print the help of the given script (see notes)

    INSTALLATION
      Put something like this in your $HOME/.bashrc:

      . /path/to/p.sh (if you installed with make /usr/local/opt)

      Optionally you can set these vars in a file named, ~/.pshrc:

      Set PSH_CMD to change the command name (default p).
      Set PSH_DIR to change dir where you store scripts (default ~/.pshdir).
      Set PSH_LIST to change the command that lists available scripts (default ls).

      this default help script is automatically installed,
      all you have to do now is put your scripts in PSH_DIR !!

    NOTE
      heavily inspired by z.sh`
