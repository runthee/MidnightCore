#!/system/bin/sh

MODDIR=${0%/*};

# restore boot animation for Magisk post-fs mode loading
if [ ! -f /data/adb/magisk_simple/system/media/bootanimation.zip ]; then
  mkdir -p /data/adb/magisk_simple/system/media;
  cp -rf $MODDIR/bootanimation.zip /data/adb/magisk_simple/system/media/;
fi;