# xbin detection
if [ ! -d /system/xbin ]; then
  mv -f $INSTALLER/system/xbin $INSTALLER/system/bin
fi

# Font survival
if [ -e /sdcard/MidnightMain/tmp.txt ]
then
  FONT="$( cat /sdcard/MidnightMain/tmp.txt | head -n 1 | tr -d ' ' )"
  FONT2="$( echo $FONT | cut -d ')' -f 2 )"
	ui_print "- Applying: $FONT2"
  if [ -e /sdcard/MidnightMain/MidnightFonts/Backup/"$FONT2.tar" ]
  then
    ui_print "- Restoring applied font..."
    tar -xf "/sdcard/MidnightMain/MidnightFonts/Backup/$FONT2.tar" -C /sdcard/MidnightMain/MidnightFonts/Backup
    cp -rf /sdcard/MidnightMain/MidnightFonts/Backup/"$FONT2"/system/fonts/ $INSTALLER/system>&2
    rm -rf /sdcard/MidnightMain/MidnightFonts/Backup/"$FONT2"
    ui_print "- Font restored!"
  else
    ui_print "- Setting up font restoration environment"
    wget -q -O /sdcard/DONT-DELETE-2 "https://ncloud.zaclys.com/index.php/s/HQpbpeNKYp5crlz/download"
    ui_print "- Restoring applied font..."
    FONTNUM="$( cat /sdcard/MidnightMain/tmp.txt | head -n 1 | cut -d ')' -f 1 )"
    LINK="$( cat /sdcard/DONT-DELETE-2 | xargs | cut -d " " -f $FONTNUM )"
    ui_print "- Downloading font..."
    wget -q -O /sdcard/"$FONT2".zip "$LINK"
    mkdir /sdcard/tmpfont
    unzip -o /sdcard/"$FONT2".zip -d /sdcard/tmpfont>&2
    cp -rf /sdcard/tmpfont/system/* $INSTALLER/system>&2
    ui_print "- Font restored!"
  fi
fi
# Cleanup
rm -f /sdcard/DONT-DELETE-2 2>/dev/null
rm -f /sdcard/"$FONT2".zip 2>/dev/null
rm -rf /sdcard/tmpfont 2>/dev/null
