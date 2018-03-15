#!/sbin/sh
# 
# /system/addon.d/70-midcore.sh

. /tmp/backuptool.functions

save_files() {
cat <<EOF
fonts/*
media/bootanimation.zip
EOF
}

case "$1" in
  backup)
    save_files | while read FILE DUMMY; do
      backup_file $S/"$FILE"
    done
    # Backup custom system fonts manually since files can differ across devices
    cp -rpf /system/media/audio /tmp/audio
    cp -rpf /system/fonts /tmp/fonts
  ;;
  restore)
    save_files | while read FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
      [ -f "$C/$S/$FILE" ] && restore_file $S/"$FILE" "$R"
    done
  ;;
  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
  ;;
  post-restore)
    # Wipe ROM system audio then restore custom
    rm -rf /system/media/audio
    cp -rpf /tmp/audio /system/media
    rm -rf /tmp/audio
    rm -rf /system/fonts
    cp -rpf /tmp/fonts /system/
    rm -rf /tmp/fonts
  ;;
esac
