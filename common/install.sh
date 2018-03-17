# xbin detection
if [ ! -d /system/xbin ]; then
  mv -f $INSTALLER/system/xbin $INSTALLER/system/bin
fi

# Font survival
if [ -e /sdcard/MidnightMain/tmp.txt ]
then
  FONT="$( cat /sdcard/MidnightMain/tmp.txt | xargs )"
  FONT2="$( echo $FONT | cut -d ' ' -f 2 )"
  if [ -e /sdcard/MidnightMain/MidnightFonts/Backup/$FONT2 ]
  then
    ui_print "- Restoring applied font..."
    cp -f /sdcard/MidnightMain/MidnightFonts/Backup/$FONT2/system/* $MODPATH>&2
    ui_print "- Font restored!"
  else
    ui_print "- Setting up font restoration environment"
    wget -q -O /sdcard/DONT-DELETE "https://ncloud.zaclys.com/index.php/s/jWG7VgSePf30Dat/download"
    wget -q -O /sdcard/DONT-DELETE-2 "https://ncloud.zaclys.com/index.php/s/HQpbpeNKYp5crlz/download"
    ui_print "- Restoring applied font..."
    FONT="$( cat /sdcard/MidnightMain/tmp.txt | xargs )"
    FONT2="$( echo $FONT | cut -d ' ' -f 2 )"
    FONTNUM="$( cut -d ')' -f 1 /sdcard/MidnightMain/tmp.txt )"
    LINK="$( cat /sdcard/DONT-DELETE-2 | xargs | cut -d " " -f $FONTNUM )"
    ui_print "- Downloading font..."
    wget -q -O /sdcard/"$FONT2".zip "$LINK"
    unzip -o /sdcard/"$FONT2".zip 'system/*' -d $MODPATH>&2
    ui_print "- Font restored!"
  fi
fi
# Cleanup
rm -f /sdcard/DONT-DELETE 2>/dev/null
rm -f /sdcard/DONT-DELETE-2 2>/dev/null
rm -f /sdcard/"$FONT2".zip 2>/dev/null

# Media survival
if [ -e /sdcard/MidnightMain/tmp2.txt ]
then
  wget -q -O /sdcard/MDONT-MDELETE "https://ncloud.zaclys.com/index.php/s/qU9KDmCjAjeB35e/download"
  wget -q -O /sdcard/MDONT-MDELETE-2 "https://ncloud.zaclys.com/index.php/s/gw69DEq0706VN03/download"
  ui_print "- Restoring applied media files..."
  MEDIA="$( cat /sdcard/MidnightMain/tmp2.txt | xargs )"
  MEDIA2="$( echo $MEDIA | cut -d ' ' -f 2 )"
  MEDNUM="$( cut -d ')' -f 1 /sdcard/MidnightMain/tmp2.txt )"
  LINK="$( cat /sdcard/MDONT-MDELETE-2 | xargs | cut -d " " -f $MEDNUM )"
  ui_print "- Downloading media files..."
  wget -q -O /sdcard/"$MEDIA2".zip "$LINK"
  mkdir $MODPATH/system/media
  unzip -o /sdcard/"$MEDIA2".zip -d $MODPATH/system/media>&2
  ui_print "- Media files restored!"
fi
# Cleanup
rm -f /sdcard/MDONT-MDELETE 2>/dev/null
rm -f /sdcard/MDONT-MDELETE-2 2>/dev/null
rm -f /sdcard/"$MEDIA2".zip 2>/dev/null