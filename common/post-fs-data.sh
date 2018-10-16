# This script will be executed in post-fs-data mode
# More info in the main Magisk thread
MODDIR=${0%/*}

test -e /data/adb/magisk && adb=adb;

MAGISK_VER_CODE=$( grep "^MAGISK_VER_CODE=" "/data/$adb/magisk/util_functions.sh" 2>/dev/null | cut -d= -f2 );
if [ "$MAGISK_VER_CODE" -lt 1640 ]; then
	basicmnt="/cache/magsik_mount"
else
	basicmnt="/data/adb/magisk_simple"
fi

if [ ! -f $basicmnt/system/media/bootanimation.zip ] && [ -f $MODDIR/system/media/bootanimation.zip ]; then
	mkdir -p $basicmnt/system/media
	cp -rf $MODDIR/system/media/bootanimation.zip $basicmnt/system/media > /dev/null 2>&1
fi
