# xbin detection
if [ ! -d /system/xbin ]; then
  mv -f $INSTALLER/system/xbin $INSTALLER/system/bin
fi

# Font survival
if [ -e /sdcard/MidnightMain/tmp.txt ]
then
  FONT="$( cat /sdcard/MidnightMain/tmp.txt | tr -d ' ' )"
  FONT2="$( echo $FONT | cut -d ')' -f 2 )"
	ui_print "- $FONT2"
  if [ -e /sdcard/MidnightMain/MidnightFonts/Backup/"$FONT2" ]
  then
    ui_print "- Restoring applied font..."
    cp -rf /sdcard/MidnightMain/MidnightFonts/Backup/"$FONT2"/system/* $INSTALLER/system>&2
    ui_print "- Font restored!"
  else
    ui_print "- Setting up font restoration environment"
    wget -q -O /sdcard/DONT-DELETE "https://ncloud.zaclys.com/index.php/s/jWG7VgSePf30Dat/download"
    wget -q -O /sdcard/DONT-DELETE-2 "https://ncloud.zaclys.com/index.php/s/HQpbpeNKYp5crlz/download"
    ui_print "- Restoring applied font..."
    FONT="$( cat /sdcard/MidnightMain/tmp.txt | tr -d ' ' )"
    FONT2="$( echo $FONT | cut -d ')' -f 2 )"
    FONTNUM="$( cut -d ')' -f 1 /sdcard/MidnightMain/tmp.txt )"
    LINK="$( cat /sdcard/DONT-DELETE-2 | xargs | cut -d " " -f $FONTNUM )"
    ui_print "- Downloading font..."
    wget -q -O /sdcard/"$FONT2".zip "$LINK"
    unzip -o /sdcard/"$FONT2".zip 'system/*' -d $INSTALLER/system>&2
    ui_print "- Font restored!"
  fi
fi
# Cleanup
rm -f /sdcard/DONT-DELETE 2>/dev/null
rm -f /sdcard/DONT-DELETE-2 2>/dev/null
rm -f /sdcard/"$FONT2".zip 2>/dev/null
