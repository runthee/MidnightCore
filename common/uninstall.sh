case $(basename $ZIP) in
  *delete*|*Delete*|*DELETE*) DELETE=true;;
esac

# Keycheck binary by someone755 @Github, idea for code below by Zappo @xda-developers
chmod 755 $INSTALLER/common/keycheck

keytest() {
  ui_print " - Vol Key Test -"
  ui_print "   Press Vol Up:"
  (/system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > $INSTALLER/events) || return 1
  return 0
}

chooseport() {
  #note from chainfire @xda-developers: getevent behaves weird when piped, and busybox grep likes that even less than toolbox/toybox grep
  while (true); do
    /system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > $INSTALLER/events
    if (`cat $INSTALLER/events 2>/dev/null | /system/bin/grep VOLUME >/dev/null`); then
      break
    fi
  done
  if (`cat $INSTALLER/events 2>/dev/null | /system/bin/grep VOLUMEUP >/dev/null`); then
    return 0
  else
    return 1
  fi
}

chooseportold() {
  # Calling it first time detects previous input. Calling it second time will do what we want
  $KEYCHECK
  $KEYCHECK
  SEL=$?
  if [ "$1" == "UP" ]; then
    UP=$SEL
  elif [ "$1" == "DOWN" ]; then
    DOWN=$SEL
  elif [ $SEL -eq $UP ]; then
    return 0
  elif [ $SEL -eq $DOWN ]; then
    return 1
  else
    ui_print "   Vol key not detected!"
    abort "   Use name change method in TWRP"
  fi
}

if [ -z $DELETE ]; then
  if keytest; then
    FUNCTION=chooseport
  else
    FUNCTION=chooseportold
    ui_print "   ! Legacy device detected! Using old keycheck method"
    ui_print " "
    ui_print "- Vol Key Programming -"
    ui_print "   Press Vol Up Again:"
    $FUNCTION "UP"
    ui_print "   Press Vol Down"
    $FUNCTION "DOWN"
  fi
  ui_print " "
  ui_print "- Select Option -"
  ui_print "   Remove all files related to MidnightCore: "
  ui_print "   Vol+ = Remove all files, Vol- = Do not remove files."
  ui_print "   Removing files will delete all backups as well."
  if $FUNCTION; then
    KEEP=true
  else
    DELETE=true
  fi
fi
if $KEEP; then
  ui_print "- No files removed."
else
  ui_print "- Removing related files..."
  if [ -d /sdcard/MidnightMain ]; then
    rm -rf /sdcard/MidnightMain
  fi
  if [ -d /sdcard/'MidnightMain(Beta)' ]; then
    rm -rf /sdcard/'MidnightMain(Beta)'
  fi
  if [ -d /sdcard/MidBack ]; then
    rm -rf /sdcard/MidBack
  fi
fi
	