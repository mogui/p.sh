NAME
  p - a friendly script launcher

USAGE
  p               # lists all installed script
  p [script]      # run the given script
  p help          # run the help script giving this help
  p help [script] # print the help of the given script (see notes)

INSTALLATION
  Put something like this in your /Users/niko.usai/.bashrc:

  . /path/to/p.sh

  Optionally you can set these vars in a file named, /Users/niko.usai/.pshrc:

  Set  to change the command name (default p).
  Set /Users/niko.usai/scripts/pshdir to change dir where you store scripts (default /Users/niko.usai/.pshdir).
  Set ls to change the command that lists available scripts (default ls).

  this default help script is automatically installed,
  all you have to do now is put your scripts in /Users/niko.usai/scripts/pshdir !!

NOTE
  heavily inspired by z.sh
